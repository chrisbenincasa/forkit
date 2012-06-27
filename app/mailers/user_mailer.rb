class UserMailer < ActionMailer::Base
  default from: "chrisbenincasa@gmail.com"

  def test_email(user)
    @email = user.email
    @name = user.name
    mail(:to => @email, :subject => 'test e-mail')
  end
  
  def activate_email(user)
    @user = user
    @name = user.name
    @email = user.email
    mail(:to => user.email, :subject => 'Some testing shit')
  end

  def password_reset_email(user)
    @user = user
    mail :to => user.email, :subject => 'Password reset for Forkin.it'
  end
end
