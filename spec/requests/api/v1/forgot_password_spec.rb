require 'rails_helper'

RSpec.describe Api::V1::ForgotPasswordController, :type => :request do
  let (:user) {FactoryGirl.create(:user,:password_reset_token => "123456", :password_reset_sent_at => Time.current)}

  context 'forgotPassword' do
    context 'positive' do
      it 'should send an email to reset password' do
        credentials = {email: user.email}
        post "/api/v1/forgot_password", credentials
        expect{post "/api/v1/forgot_password", credentials}.to change{ActionMailer::Base.deliveries.count}.by(1)
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body["message"]).to eq("The reset password instructions will be sent to this email")
      end
    end

    context 'negative' do
      it 'should not send an email to reset password for invalid email' do
        credentials = {email: "invalid email"}
        expect{post "/api/v1/forgot_password", credentials}.to change{ActionMailer::Base.deliveries.count}.by(0)
        post "/api/v1/forgot_password", credentials
        body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(body["message"]).to eq("The email address you entered could not be found. Please try again")
      end
    end
  end

  context "Reset Password" do
    context "Positive" do
      it "should reset the password with a valid password_reset_token" do
        params = {password: "Password@1", password_confirmation: "Password@1", password_reset_token: user.password_reset_token}
        put "/api/v1/reset_password", params
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body["message"]).to eq("Password updated successfully")
      end
    end


    context "Negative" do
      it "should not update the password if the password_reset_token expires" do
        user1 = FactoryGirl.create(:user, :password_reset_token => "123456", :password_reset_sent_at =>  Time.current.advance(:hours => -3))
        params = {password: "Password@1", password_confirmation: "Password@1", password_reset_token: user1.password_reset_token}
        put "/api/v1/reset_password", params
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expect(body["message"]).to eq("Password reset has expired")
      end

      it "should not update the password if the password and password_confirmation does not match" do
        params = {password: "Password@1", password_confirmation: "Password", password_reset_token: user.password_reset_token}
        put "/api/v1/reset_password", params
        expect(response.status).to eq(422)
        body = JSON.parse(response.body)
        expect(body["message"]).to eq("Couldn't save the password. Kindly look at the errors")
      end

    end
  end

end