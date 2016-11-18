class Api::V1::AuthenticationsController < ApplicationController

  def authenticate
    @users = User.find_by_email(params[:email])
    if @users && @users.authenticate(params[:password])
      render :json => {data: @users, message: "You have successfully authenticated",:status => 200}
    else
      render_invalid_json
    end
  end

  private

  def render_invalid_json
    render json: { message: I18n.t("api.authentication_failure"), error: {base: "Invalid Email or Password"} },status: 422
  end
end
