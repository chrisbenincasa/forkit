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
      @forkedRecipes = @user.recipes.where("personal_recipe_infos.favorite IS TRUE")
      @ratedRecipes = @user.recipes.where("personal_recipe_infos.rating IS NOT NULL")
      @createdRecipes = @user.recipes.find_all_by_created_by(@user.id)[0..3]
    else
      @newestRecipes = Recipe.limit(4)
    end
  end

  def new
    @user = User.new
  end

  def me
    @user = current_user
    @avatarUrl = get_avatar_url(@user)
    @recentFav = @user.recipes.where("personal_recipe_infos.favorite IS TRUE").limit(1)[0]
    @recentCreated = @user.recipes.where(:created_by => @user.id).limit(1)[0]
    if @user.name
      @name = @user.name
    else
      @name = @user.email
    end
    render 'show'
  end

  def show
    @page = false;
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
      return
    end
    @avatarUrl = get_avatar_url(@user)
    if @user.name
      @name = @user.name
    else
      @name = @user.email
    end
    @recentFav = @user.recipes.where("personal_recipe_infos.favorite IS TRUE").limit(1)[0]
    @recentCreated = @user.recipes.where(:created_by => @user.id).limit(1)[0]
    logger.debug @recentFav.inspect
    logger.debug @recentCreated.inspect
    respond_to do |format|
      format.html
      format.json {render :partial => 'users/show.json'}
    end
  end

  def not_found
    #user not found function
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, :notice => 'Signed up!'
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
    @recipes = @user.recipes
    @avatarUrl = get_avatar_url(@user)
    if @user.name
      @name = @user.name
    else
      @name = @user.email
    end
    @createdRecipes = @user.recipes.where(:created_by => @user.id)
    if @createdRecipes.count <= 8
      @page = false
    end
    logger.debug @createdRecipes.count
    respond_to do |format|
      format.html
      format.json {render :partial => 'users/show.json'}
    end
  end

  def faved_recipes
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
      return
    end
    @favedRecipes = @user.recipes.where("personal_recipe_infos.favorite IS TRUE").page(params[:page]).per(9)
    respond_to do |format|
      format.html {render :layout => 'wall'}
      format.json {render :json => @favedRecipes}
    end
  end

  def invite
    if current_user
      auth = Authorization.find_by_user_id_and_provider(current_user.id, 'facebook')
      if auth
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
end
