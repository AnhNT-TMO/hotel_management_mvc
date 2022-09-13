class UsersController < ApplicationController
  before_action :authenticate_user!, :find_user,
                except: %i(new create)
  before_action :correct_user, only: %i(edit update)
  before_action :authen_old_password, only: :update

  def show; end

  def new
    @user = User.new
  end

  def create; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".update_message"
      redirect_to root_path
    else
      flash.now[:danger] = t ".update_fail"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(User::UPDATABLE_ATTRS)
  end

  def logged_in_user
    return if user_signed_in?

    flash[:danger] = t ".login_message"
    redirect_to login_url
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t ".alert_correct_user"
    redirect_to root_url
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".alert_user"
    redirect_to root_path
  end

  def authen_old_password
    return if @user&.authenticate params[:user][:old_password]

    flash.now[:danger] = t ".old_password_fail"
    render :edit
  end
end
