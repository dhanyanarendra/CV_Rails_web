require 'rails_helper'
require 'base64'

RSpec.describe Api::V1::DescribesController, :type => :request do

  let(:user) {FactoryGirl.create(:user)}
  let(:describe) {FactoryGirl.create(:describe, :user => user)}
  let(:comment) {FactoryGirl.create(:comment, :describe => describe,:user => user)}

  let(:request_headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => user.auth_token
    }
  }

  describe 'index' do
    context "Positive Case" do
      it "should list all the comments" do
       describe1 = FactoryGirl.create(:describe, :user => user)
       describe2 = FactoryGirl.create(:describe, :user => user)

       comment1 = FactoryGirl.create(:comment, user_id:user.id, describe_id:describe1.id)
       comment2 = FactoryGirl.create(:comment, user_id:user.id, describe_id:describe2.id)
       comment3 = FactoryGirl.create(:comment, user_id:user.id, describe_id:describe1.id)
       get "/api/v1/describe/#{describe1.id}/comments", {}, request_headers
       expect(response.status).to eq(200)
       response_body = JSON.parse(response.body)
       expect(response_body["data"].size).to eq(2)
       expect(response_body["data"].first.keys).to eq(["id", "comment_body", "user_id", "describe_id", "created_at", "updated_at", "commented_name", "commented_image"])
       expect(response_body["data"].first["comment_body"]).to eq(comment.comment_body)
       expect(response_body["data"].first["comment_body"]).to eq(comment.comment_body)
       expect(response_body["data"].first["comment_body"]).to eq(comment.comment_body)
      end
    end
  end

  describe 'create' do
    context "Positive case" do
      it "should create a comments" do
        credentials = {comment: {comment_body: "New Clean City",user_id: user.id ,describe_id:describe.id}}
        post "/api/v1/#{user.id}/describe/#{describe.id}", credentials.to_json, request_headers
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["message", "data"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully created comment")
      end
    end

    context "Negative cases" do
      it "should throw error without params" do
        credentials = {comment: {comment: ""}}
        post "/api/v1/#{user.id}/describe/#{describe.id}", credentials.to_json ,request_headers
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(404)
        expect(response_body["message"]).to eq("Invalid Input")
      end
      it "should throw error if comment description is empty" do
        credentials = {comment: {comment_body: "",user_id: user.id ,describe_id:describe.id}}
        post "/api/v1/#{user.id}/describe/#{describe.id}", credentials.to_json ,request_headers
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body["message"]).to eq("Invalid comment")
      end

    end
  end

  describe 'update' do
    context "Positive Case" do
      it "Should update comment description" do
        comment = FactoryGirl.create(:comment, user_id: user.id ,describe_id:describe.id)
        comment_params = {comment_body: "Bangalore city clean"}
        put "/api/v1/users/#{user.id}/describe/#{describe.id}/comment/#{comment.id}", comment_params.to_json,request_headers
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["data", "message", "status" ])
        expect(response_body["data"]["comment_body"]).to eq("Bangalore city clean")
        expect(response_body["message"]).to eq("Successfully updated comment")
      end

    end

    context "Negative Cases" do
      it "should show proper error message if it fails to find the project with the id passed" do
        comment = FactoryGirl.create(:comment, user_id: user.id ,describe_id: describe.id)
        comment_params = {comment_body: "Bangalore city clean"}
        put "/api/v1/users/#{user.id}/describe/9999/comment/#{comment.id}", comment_params.to_json,request_headers
        expect(response.status).to eq(404)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["message"])
        message = response_body["message"]
        expect(message).to eq("Describe not found")
      end

      it "should show proper error message if it fails to find the comment with the id passed" do
        comment = FactoryGirl.create(:comment, user_id: user.id ,describe_id: describe.id)
        put "/api/v1/users/#{user.id}/describe/#{describe.id}/comment/9999", {}
        expect(response.status).to eq(404)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["message"])
        message = response_body["message"]
        expect(message).to eq("Comment not found")
      end

      it "should show proper error message if the comment field is empty" do
        comment = FactoryGirl.create(:comment, user_id: user.id ,describe_id: describe.id)
        comment_params = {comment_body: ""}
        put "/api/v1/users/#{user.id}/describe/#{describe.id}/comment/#{comment.id}",  comment_params.to_json,request_headers
        expect(response.status).to eq(422)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["error","message"])
        message = response_body["message"]
        expect(message).to eq("Please fill the empty fields")
      end
    end
  end

  describe 'destroy' do
    context "Positive Case" do
      it "should delete comment" do
        comment = FactoryGirl.create(:comment,comment_body:"Mysore city clean", user_id: user.id,describe_id: describe.id)

        delete "/api/v1/users/#{user.id}/describe/#{describe.id}/comment/#{comment.id}", comment.to_json,request_headers

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(Comment.count).to eq(0)
        expect(response_body.keys).to eq(["data", "message", "status"])
        expect(response_body["message"]).to eq("Comment has been deleted successfully")
      end
    end


    context "Negative cases" do
      it "should show proper error message if it fails to find the comment with the id passed" do
        comment = FactoryGirl.create(:comment,comment_body:"Mysore city clean", user_id: user.id,describe_id: describe.id)
        delete "/api/v1/users/#{user.id}/describe/#{describe.id}/comment/9999", {}
        expect(response.status).to eq(422)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["data", "message"])
        message = response_body["message"]
        expect(message).to eq(" Sorry !could not delete the comment ")
      end

      it "should show proper error message if it fails to find the project with the id passed" do
        comment = FactoryGirl.create(:comment, user_id: user.id ,describe_id: describe.id)
        delete "/api/v1/users/#{user.id}/describe/9999/comment/#{comment.id}", {}
        expect(response.status).to eq(404)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["message"])
        message = response_body["message"]
        expect(message).to eq("Describe not found")
      end

    end
  end
end
