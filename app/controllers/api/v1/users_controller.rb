class Api::V1::UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :set_user, except: %i(create)
  before_action :correct_user, only: %i(update destroy)
  # GET /users/1
  def show
    render json: @user
  end

  def create
    @user = User.new user_params
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update user_params
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy

    render json: {success: I18n.t("api.v1.success")}, status: :ok
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])

    return if @user

    render json: {error: I18n.t("api.v1.cannot_found")}, status: :not_found
  end

  def user_params
    params.require(:user).permit(User::UPDATABLE_ATTRS)
  end

  def correct_user
    return if @current_user.id == params[:id].to_i

    render json: {error: I18n.t("api.v1.cannot_delete_update")},
           status: :not_found
  end
end
