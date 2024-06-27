class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "password reset"
  end
end
