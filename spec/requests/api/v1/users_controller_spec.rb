require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :request do

  let(:params)  {{user_name:"test1234",email:"sample@gmail.com", password: "password123"}}
  let(:user) {FactoryGirl.create(:user)}


let(:request_headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => user.auth_token
    }
  }

  describe 'sign up' do
    context "Positive case" do
      it "should create a user" do
        post "/api/v1/users", params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["message", "data", "status"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully created user")
      end
    end

    context "Negative case" do
      pending "should throw error without params" do
        post "/api/v1/users",{}
        response_body = JSON.parse(response.body)
        expect(response_body["status"]).to eq(422)
        expect(response_body["message"]).to eq("Fill the empty fields")
      end
    end
  end

  context "follow_user" do
  context "Positive case" do
    it "should follow user based on project id " do
      follow_params = {follow: true}
      post "/api/v1/#{user.id}/user/follow_user", follow_params.to_json ,request_headers
      expect(response.status).to eq(200)
      response_body =JSON.parse(response.body)
    end
  end
end

context "unfollow_user" do
  context "positive case" do
    it "should unfollow user based on user id " do
      unfollow_params = {unfollow: false}
      post "/api/v1/#{user.id}/user/follow_user",unfollow_params.to_json ,request_headers
      expect(response.status).to eq(200)
      response_body =JSON.parse(response.body)
      expect(response_body["message"]).to eq("Unfollow")
    end
  end
end

  describe "update" do
    context "positive case" do
      it "should be able to edit user details" do
        put "/api/v1/users/#{user.id}", params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["data","message", "status"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully updated user")
      end
    end

    context "Negative Case" do
      it "Should throw an error while updating invalid user" do
        put "/api/v1/users/9999", {}
        response_body =JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body.keys).to eq(["message"])
        message = response_body["message"]
        expect(message).to eq("User not found")
      end
    end
  end

  describe "list" do
    context "Positive Case" do
      it "should list users based on ID" do
        get "/api/v1/users/#{user.id}",{},request_headers 
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully listed user")
      end
    end

    context "Negative Case" do
      it "should throw an error for invalid user ID " do
        get "/api/v1/users/9999",{},request_headers
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        message = response_body["message"]
        expect(message).to eq("Invalid user ID")
      end

    end
  end

  describe "Destroy"do
  context "Positive case" do
    it "should remove user profile image" do
      delete "/api/v1/remove_profile_image/#{user.id}" , params
      response_body = JSON.parse(response.body)
      data = response_body["data"]
      expect(response.status).to eq(200)
      message = response_body["message"]
      expect(message).to eq("Successfully removed user's profile image")
    end
  end

  context "Negative case" do
    it "should throw error for invalid ID" do
      delete "/api/v1/remove_profile_image/9999"
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(422)
      message = response_body["message"]
      expect(message).to eq("Invalid user ID")
    end
  end
end
end