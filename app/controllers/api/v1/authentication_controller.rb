class Api::V1::AuthenticationController < ApplicationController
  before_action :find_by_email, only: :login
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.zone.now + Settings.api.v1.authen.exp.hours.to_i
      render_json(token, time, @user)
    else
      render json: {error: I18n.t("api.v1.unauthorized")}, status: :unauthorized
    end
  end

  private

  def render_json token, time, user
    render json: {token: token, exp: time.strftime(
      Settings.api.v1.authen.strftime_exp
    ),
                  email: user.email}, status: :ok
  end

  def find_by_email
    @user = User.find_by(email: params[:email])
  end

  def login_params
    params.permit(:email, :password)
  end
end
