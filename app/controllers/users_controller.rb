require 'net/http'
require 'uri'
require 'digest/md5'
require 'json'

class UsersController < ApplicationController
  before_filter :is_logged_in?, :only => [:new]
  layout 'users'

  def index
    @page = false;
    if current_user
      @user = current_user
      @firstName = name_to_use(@user)[1]
      puts session[:recent_recipes].inspect
      if session[:recent_recipes]
        r_view_recipes = Recipe.find(session[:recent_recipes])
        @recentlyViewed = session[:recent_recipes].map{|id| r_view_recipes.detect{|each| each.id == id}}.reverse[0..3]
      end
    else
      @newestRecipes = Recipe.limit(4)
    end
  end

  def new
    @page = false
    @user = User.new
  end

  def me
    @user = current_user
    @avatarUrl = get_avatar_url(@user)
    @recentFav = @user.recipes.where("personal_recipe_infos.favorite IS TRUE").limit(1).first
    @recentCreated = @user.recipes.where(:created_by => @user.id).limit(1).first
    names = name_to_use(@user)
    @name = names[0]
    @first = names[1]

    render 'show'
  end

  def show
    @page = false;
    begin
      @user = User.includes(:recipes => [:ingredients]).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
      return
    end
    @avatarUrl = get_avatar_url(@user)
    if current_user && current_user == @user
      @name = current_user.display_name
      @first = 'You'
      @possessive = 'Your'
    else
      names = name_to_use(@user)
      @name = names[0]
      @first = names[1]
      @possessive = @first + "'s"
    end
    @allIngredients = []
    @user.recipes.each{|r| r.ingredients.each{|i| @allIngredients.push(i)} }
    favorites = get_faves(@user)
    created = @user.recipes.select{|r| r.created_by == @user.id}
    @recentFav = favorites.first
    @recentCreated = created.first
    @totalFav = favorites.count
    @totalCreated = created.count
    respond_to do |format|
      format.html
      format.json {render :partial => 'users/show.json'}
    end
  end

  def not_found
    #user not found function
  end

  def edit
    @page = false
    @user = current_user
    logger.debug current_user
    @passwordChange = Authorization.find_by_user_id_and_provider(@user.id, 'facebook') == nil ? true : false 
  end

  def update
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user == User.authenticate(@user.email, params['old_password'])
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html {redirect_to root_url, :notice => 'Successfully updated!'}
          format.json {head :no_content}
        else
          format.html { render action: 'edit' }
          format.json { render json: @user.errors, status: :unprocessable_entity}
        end
      end
    end
  end

  def new_user_activate
    token = Token.find_by_active_token(params[:activation_id])
    if token
      if token.user.update_attributes(:is_activated => true)
        redirect_to root_url, :notice => 'Successfully activated your account!'
      else
        redirect_to root_url, :notice => 'Something went wrong with activation. Try again later.'
      end
    else
      redirect_to root_url, :notice => 'Invalid activation id.'
    end
  end

  def profile_activate
    @user = current_user
    if @user
      if @user.token
        @user.token.active_token = @user.generate_token
        if !@user.token.save
          redirect_to root_url, :notice => 'Something went wrong with activation. Try again later.'
        end
      else
        @user.create_token(:active_token => @user.generate_token)
      end
      @user.token.send_activation_email
      redirect_to root_url, :notice => "Activation e-mail sent to #{@user.email}"
    else
      redirect_to current_user, :notice => 'You don\'t have access to this page.'
    end
  end

  def create
    params[:user]['display_name'] = params[:user]['name']
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      if @user.token
        @user.token.active_token = @user.generate_token
        if !@user.token.save
          redirect_to root_url, :notice => 'Activation token could not be saved. Go to profile page to activate your account.'
        end
      else
        @user.create_token(:active_token => @user.generate_token)
      end
      @user.token.send_activation_email
      redirect_to root_url, :notice => 'Activation e-mail sent!'
    else
      render 'new'
    end
  end

  def recipes
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
      return
    end
    names = name_to_use(@user)
    @name = names[0]
    @first = names[1]
    @recipes = @user.recipes
    @avatarUrl = get_avatar_url(@user)
    @createdRecipes = @user.recipes.where(:created_by => @user.id)
    @totalPages = (@createdRecipes.count / 8.0).ceil
    @createdRecipes = @createdRecipes.order('created_at DESC').page(params[:page]).per(8)
    respond_to do |format|
      format.html
      format.js { 
        @page = params[:page].to_i
        @totalPages = @totalPages
      }
      format.json {render :partial => 'users/show.json'}
    end
  end

  def faved_recipes
    begin
      @user = User.includes(:personalRecipeInfo, :recipes => [:ingredients]).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
      return
    end
    names = name_to_use(@user)
    @name = names[0]
    @first = names[1]

    @favedRecipes = get_faves(@user).page(params[:page]).per(9).order('created_at DESC')
    respond_to do |format|
      format.html {render :layout => 'wall'}
      format.json {render :json => @favedRecipes}
    end
  end

  def invite
    if current_user
      auth = current_user.authorizations.select{|auth| auth.provider == 'facebook'}.first
      if auth or auth.empty?
        uri = URI.parse("https://graph.facebook.com/#{auth.uid}/friends?fields=installed,name&access_token=#{auth.access_token}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        data = Net::HTTP::Get.new(uri.request_uri)
        @friends = JSON.parse(http.request(data).body)['data']
        @friends = @friends.sort_by{|hsh| hsh['name']}
      end
    end
    render :layout => 'wall'
  end

  def favorite
    user = current_user
    recipe = Recipe.find_by_url_slug(params[:recipe_id])
    info = user.personalRecipeInfo.find_by_recipe_id(recipe.id)
    if info
      if info['favorite'] == false
        recipe['favorites'] += 1
        info['favorite'] = true
      else
        recipe['favorites'] -= 1
        info['favorite'] = false
      end
    else
      user.recipes << recipe
    end
    if info.save && recipe.save
      render :json => recipe
    else
      render :json => recipe
    end
  end

  private

  def get_faves(user)
    user.recipes.where("personal_recipe_infos.favorite IS TRUE")
  end

  def get_avatar_url(user)
    authorization = Authorization.find_by_user_id_and_provider(user.id, 'facebook')
    if authorization
      return "http://graph.facebook.com/#{authorization.uid}/picture"
    else
      digestHash = Digest::MD5.hexdigest(user.email.downcase)
      return "http://www.gravatar.com/avatar/#{digestHash}?s=50"
    end
  end

  def is_logged_in?
    if current_user
      redirect_to root_url, :notice => "You're already logged in!"
    end
  end

  def name_to_use(user)
    if user.display_name
      return [user.display_name, user.display_name.split(' ')[0]]
    elsif user.name
      return [user.name, user.name.split(' ')[0]]
    else
      return [user.email, user.email]
    end
  end
end
