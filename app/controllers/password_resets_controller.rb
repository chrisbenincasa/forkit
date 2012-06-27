class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.includes(:token).find_by_email(params[:email])
    if user
      if user.token
        user.token.reset_token = user.generate_token
        if !user.token.save
          redirect_to root_url, :notice => 'Password reset e-mail could not be sent at this time.'
        end
      else
        user.create_token(:reset_token => user.generate_token)
      end
      user.token.send_password_reset
      redirect_to root_url, :notice => 'Password reset e-mail sent.'
    else
      redirect_to root_url, :notice => 'User not found.'
    end
  end

  def edit
    token = Token.find_by_reset_token(params[:id])
    @user = token.user
  end

  def update
    token = Token.includes(:user).find_by_reset_token(params[:id])
    @user = token.user
    if token.updated_at < 2.hours.ago
      redirect_to root_url, :notice => 'Password reset has expired.'
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => 'Password has been reset.'
    else
      render :edit
    end
  end
end
