class Token < ActiveRecord::Base
  belongs_to :user
  #attr_accessable 

  def send_activation_email
    UserMailer.activate_email(self.user).deliver
  end

  def send_password_reset
    UserMailer.password_reset_email(self.user).deliver
  end
end
