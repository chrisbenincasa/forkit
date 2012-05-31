class UsersController < ApplicationController
  def index
    puts cookies.inspect
    @user = current_user
  end

  def new
    @user = User.new
  end

  def show
    puts session
    @user = User.find(params[:id])
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

end
