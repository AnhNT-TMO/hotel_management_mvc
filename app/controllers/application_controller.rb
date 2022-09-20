class ApplicationController < ActionController::Base
  include Pagy::Backend
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json{head :forbidden, content_type: "text/html"}
      format.html do
        redirect_to main_app.root_url,
                    notice: flash[:danger] = exception.message
      end
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def logged_in_user
    return if user_signed_in?

    flash[:danger] = t ".logged_in_alert"
    redirect_to login_url
  end

  def after_sign_in_path_for resource
    if resource.admin?
      admin_rooms_path
    else
      root_path
    end
  end

  def configure_permitted_parameters
    added_attrs = %i(name phone email password password_confirmation
      remember_me)
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
