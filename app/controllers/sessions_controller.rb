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
      session[:user_id] = @authorization.user_id
      redirect_to root_url
    else
      user = User.new(:name => auth_hash['info']['name'], :email => auth_hash['info']['email'], :username => auth_hash['info']['nickname'])
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
      if user.save(:validate => false)
        session[:user_id] = user.id
        redirect_to root_url
      else
        render :text => user.errors.full_messages
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Logged out!'
  end
end
