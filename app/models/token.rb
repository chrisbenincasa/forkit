class Token < ActiveRecord::Base
  belongs_to :user

  def send_password_reset
    UserMailer.password_reset_email(self.user).deliver
  end
end
