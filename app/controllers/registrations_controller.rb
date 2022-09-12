class RegistrationsController < Devise::RegistrationsController
  after_action :send_mail, only: :create

  def create
    super
    @user = User.new user_params
  end

  private

  def user_params
    params.require(:user).permit(User::UPDATABLE_ATTRS)
  end

  def send_mail
    RegisterMailer.register_mailer(@user).deliver_later
  end
end
