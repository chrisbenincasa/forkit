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
end
