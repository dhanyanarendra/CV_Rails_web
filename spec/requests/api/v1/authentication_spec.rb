require 'rails_helper'

RSpec.describe Api::V1::AuthenticationsController, :type => :request do
    let!(:user) { FactoryGirl.create(:user) }



    describe "Authenticate" do

        context "Positive case" do
            it "should return user information" do
                login_credentials = {email:user.email , password:user.password}
                post "/api/v1/authenticate" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(200)
                expect(response_body["message"]).to eq("You have successfully authenticated")
            end
        end

        context "Negative case" do
            it "should return error for invalid username" do
                login_credentials = {email:"invalid username" , password:user.password}
                post "/api/v1/authenticate" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(422)
                expect(response_body["message"]).to eq("Authentication Failure")
                expect(response_body["error"]["base"]).to eq("Invalid Email or Password")

            end
            it "should return error for invalid password" do
                login_credentials = {email:user.email , password:"invalid password"}
                post "/api/v1/authenticate" , login_credentials
                response_body =JSON.parse(response.body)
                expect(response.status).to eq(422)
                expect(response_body["message"]).to eq("Authentication Failure")
                expect(response_body["error"]["base"]).to eq("Invalid Email or Password")
            end
        end

    end

end