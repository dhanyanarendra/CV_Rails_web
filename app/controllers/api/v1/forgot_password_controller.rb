module Api
  module V1
    class ForgotPasswordController < ApplicationController

      def forgot_password
        @user = User.find_by_email(params[:email])
        if @user.present?
          @user.generate_password_reset_token
          @user.save
          UsersMailer.forgot_password(@user).deliver_now
          render :json => { :success => true, :password_reset_token => @user.password_reset_token,:message => I18n.t("api.reset_password_email_success")}
        else
          render_invalid_json(I18n.t("api.reset_password_email_failure"))
        end
      end

      def reset_password
        @user = User.find_by_password_reset_token(params[:password_reset_token])
        if @user
          if @user.password_reset_sent_at < 1.hours.ago
            render_invalid_json(I18n.t("password.expire"))
          elsif @user.update_attributes(user_params)
            @user.update_attribute(:password_reset_token, nil)
            @remote_ip=request.remote_ip
            UsersMailer.reset_password(@user,@remote_ip).deliver_now
            render json: { success: true, data: @user, message: I18n.t("password.update"), status: 200 }
          else
            render_invalid_json(I18n.t("password.update_failed"))
          end
        else
          render_invalid_json(I18n.t("password.not_found"))
        end
      end

      private

      def user_params
        params.permit(:password,:password_confirmation)
      end


      def render_invalid_json(message)
        render :json => { success: false, error: @user ? @user.errors : {}, message: message }, status: 422
      end
    end
  end
end