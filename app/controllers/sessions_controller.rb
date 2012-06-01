class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => 'Logged in!'
    else
      flash.now.alert = 'Something went wrong.'
      render 'new'
    end
  end

  def omni
    puts request.env['omniauth.auth'].inspect
    auth_hash = request.env['omniauth.auth']
    @authorization = Authorization.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])
    if @authorization
      render :text => "Welcome back #{@authorization.user.name}"
    else
      user = User.new( :name => auth_hash['user_info']['name'], :email => auth_hash['user_info']['email'])
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
      user.save
 
      render :text => "Hi #{user.name}! You've signed up."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Logged out!'
  end
end
