require 'net/http'
require 'uri'
require 'digest/md5'
require 'json'

class UsersController < ApplicationController
  before_filter :is_logged_in?, :only => [:new]

  def index
    if current_user
      @user = current_user
      @forkedRecipes = @user.recipes.where("personal_recipe_infos.favorite IS TRUE").limit(8)
      @ratedRecipes = @user.recipes.where("personal_recipe_infos.rating IS NOT NULL").limit(8)
      @createdRecipes = @user.recipes.find_all_by_created_by(@user.id)
    end
  end

  def new
    @user = User.new
  end

  def me
    @user = current_user
    @avatarUrl = get_avatar_url(@user)
    @ratedRecipes = @user.recipes.where("personal_recipe_infos.rating IS NOT NULL").limit(8)
    @forkedRecipes = @user.recipes.where("personal_recipe_infos.favorite IS TRUE").limit(8)
    @createdRecipes = @user.recipes.find_all_by_created_by(@user.id)
    if @user.name
      @name = @user.name
    else
      @name = @user.email
    end
    render 'show'
  end

  def show
    @user = User.find(params[:id])
    @avatarUrl = get_avatar_url(@user)
    if @user.name
      @name = @user.name
    else
      @name = @user.email
    end
    @ratedRecipes = @user.recipes.where("personal_recipe_infos.rating IS NOT NULL").limit(8)
    @forkedRecipes = @user.recipes.where("personal_recipe_infos.favorite IS TRUE").limit(8)
    @createdRecipes = @user.recipes.find_all_by_created_by(@user.id)
    respond_to do |format|
      format.html
      format.json {render :partial => 'users/show.json'}
    end
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
    @user = User.find(params[:id])
    @recipes = @user.recipes
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
  end

  def favorite
    user = current_user
    recipe = Recipe.find_by_url_slug(params[:recipe_id])
    info = user.personalRecipeInfo.find_by_recipe_id(recipe.id)
    if info
      if info['favorite'] == false
        info['favorite'] = true
      else
        info['favorite'] = false
      end
    else
      user.recipes << recipe
    end
    if info.save
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
