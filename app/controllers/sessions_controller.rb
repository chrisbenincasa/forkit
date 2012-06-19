class SessionsController < ApplicationController
  before_filter :is_logged_in?, :only => [:new, :create, :omni]

  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      session[:recent_recipes] = Array.new
      redirect_to root_url, :notice => 'Logged in!'
    else
      flash.now.alert = 'Something went wrong.'
      render 'new'
    end
  end

  def omni
    auth_hash = request.env['omniauth.auth']
    @authorization = Authorization.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])
    if @authorization
      access_token = auth_hash['credentials']['token']
      @authorization.update_attributes(:access_token => access_token)
      if @authorization.save
        session[:user_id] = @authorization.user_id
        session[:recent_recipes] = Array.new
        redirect_to root_url
      else
        render :text => user.errors.full_messages
      end
    else
      user = User.new(:name => auth_hash['info']['name'], :email => auth_hash['info']['email'])
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"], :access_token => auth_hash['credentials']['token']
      if user.save(:validate => false)
        session[:user_id] = user.id
        session[:recent_recipes] = Array.new
        redirect_to root_url
      else
        render :text => user.errors.full_messages
      end
    end
  end

  def destroy
    session[:user_id] = nil
    session[:recent_recipes] = nil
    redirect_to root_url, :notice => 'Logged out!'
  end

  def is_logged_in?
    if current_user
      redirect_to root_url, :notice => "You're already logged in!"
    end
  end
end
