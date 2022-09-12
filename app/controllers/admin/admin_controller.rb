class Admin::AdminController < ApplicationController
  layout "admin"

  before_action :authenticate_user!, :check_admin

  def index; end

  private
  def check_admin
    return if current_user.admin?

    flash[:danger] = t ".logged_in_alert"
    redirect_to root_path
  end
end
