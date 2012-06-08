require 'net/http'
require 'uri'
require 'digest/md5'

class UsersController < ApplicationController
  before_filter :is_logged_in?, :only => [:new]

  def index
    if current_user
      @user = current_user
      @ratedRecipes = @user.recipes.where("personal_recipe_infos.rating IS NOT NULL").limit(8)
      @createdRecipes = @user.recipes.where("created_by=#{@user.id}").limit(8)
      logger.info @ratedRecipes.inspect
    end
  end

  def new
    @user = User.new
  end

  def me
    @user = current_user
    @avatarUrl = get_avatar_url(@user)
    @ratedRecipes = get_rated_recipes(@user)
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
    @ratedRecipes = @user.recipes.where("personal_recipe_infos.rating IS NOT NULL")
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

  def get_rated_recipes(user)
    nonNullRatings = user.personalRecipeInfo.where("rating IS NOT NULL")
    ratedRecipes = []
    nonNullRatings.each do |recipe|
      ratedRecipes << Recipe.find(recipe.recipe_id)
    end
    return ratedRecipes
  end

  def is_logged_in?
    if current_user
      redirect_to root_url, :notice => "You're already logged in!"
    end
  end
end
