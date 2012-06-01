class UsersController < ApplicationController
  def index
    if current_user
      @user = current_user
      @nonNullRatings = @user.personalRecipeInfo.where("rating IS NOT NULL")
      @ratedRecipes = []
      @nonNullRatings.each do |recipe|
        @ratedRecipes << Recipe.find(recipe.recipe_id)
      end
      @createdRecipes = @user.recipes.where("created_by=#{@user.id}")
    end
  end

  def new
    @user = User.new
  end

  def me
    @user = current_user
    render 'show'
  end

  def show
    @user = User.find_by_username(params[:id])
    if current_user && @user == current_user
      @identifier = "I've"
    else
      @identifier = @user.username
    end
    @nonNullRatings = @user.personalRecipeInfo.where("rating IS NOT NULL")
    @ratedRecipes = []
    @nonNullRatings.each do |recipe|
      @ratedRecipes << Recipe.find(recipe.recipe_id)
    end
    @createdRecipes = @user.recipes.where("created_by=#{@user.id}")
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
    @user = User.find_by_username(params[:id])
    @recipes = @user.recipes
  end

end
