class RegisterMailer < ApplicationMailer
  def register_mailer user
    @user = user
    mail to: @user.email, subject: t(".subject")
  end
end
