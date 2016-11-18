require 'rails_helper'
require 'base64'

RSpec.describe Api::V1::NeedCommentsController, :type => :request do
  let!(:describe) {FactoryGirl.create(:describe)}
  let!(:goal) {FactoryGirl.create(:goal, describe_id:describe.id, title:"need")}
  let!(:task) {FactoryGirl.create(:task, goal_id:goal.id, title:"title_1")}
  let(:need) {FactoryGirl.create(:need, task_id:task.id)}
  let(:user) {FactoryGirl.create(:user)}
  let(:need_comment) {FactoryGirl.create(:need_comment, :need => need,:user => user)}

  let(:request_headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => user.auth_token
    }
  }

  describe 'index' do
    context "Positive Case" do
      it "should list all  the need comments" do
       need1 = FactoryGirl.create(:need, task_id:task.id)
       need2 = FactoryGirl.create(:need, task_id:task.id)

       comment1 = FactoryGirl.create(:need_comment, user_id:user.id, need_id:need1.id)
       comment2 = FactoryGirl.create(:need_comment, user_id:user.id, need_id:need2.id)
       comment3 = FactoryGirl.create(:need_comment, user_id:user.id, need_id:need1.id)
       get "/api/v1/needs/#{need1.id}/need_comments", {}, request_headers
       expect(response.status).to eq(200)
       response_body = JSON.parse(response.body)
       expect(response_body["data"].size).to eq(2)
       expect(response_body["data"].first.keys).to eq(["id", "body_description", "user_id", "need_id", "created_at", "updated_at", "commented_name", "commented_image"])
       expect(response_body["data"].first["body_description"]).to eq(need_comment.body_description)
       expect(response_body["data"].first["body_description"]).to eq(need_comment.body_description)
       expect(response_body["data"].first["body_description"]).to eq(need_comment.body_description)
     end
   end
   context "Negative case" do
    it "should show proper error message if it fails to find the need comment with the id passed" do
      need1 = FactoryGirl.create(:need, task_id:task.id)
      need2 = FactoryGirl.create(:need, task_id:task.id)

      comment1 = FactoryGirl.create(:need_comment, user_id:user.id, need_id:need1.id)
      comment2 = FactoryGirl.create(:need_comment, user_id:user.id, need_id:need2.id)
      comment3 = FactoryGirl.create(:need_comment, user_id:user.id, need_id:need1.id)
      get "/api/v1/needs/9999/need_comments", {}, request_headers
      expect(response.status).to eq(404)
      response_body = JSON.parse(response.body)
      expect(response_body.keys).to eq(["message"])
      message = response_body["message"]
      expect(message).to eq("Need not found")
    end
  end
 end

 describe 'create' do
  context "Positive case" do
    it "should create a need comments" do
      credentials = {need_comment:{body_description: "New Clean City",user_id: user.id ,need_id:need.id}}
      post "/api/v1/users/#{user.id}/need/#{need.id}", credentials.to_json, request_headers
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response_body.keys).to eq(["message", "data"])
      data = response_body["data"]
      message = response_body["message"]
      expect(message).to eq("Successfully created need comment")
    end
  end

  context "Negative cases" do
    it "should throw error without params" do
      credentials = {need_comment: {need_comment: ""}}
      post "/api/v1/users/#{user.id}/need/#{need.id}",credentials.to_json ,request_headers
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(404)
      expect(response_body["message"]).to eq("Invalid Input")
    end
    it "should throw error if comment description is empty" do
      credentials =  {need_comment:{body_description: "",user_id: user.id ,need_id:need.id}}
      post "/api/v1/users/#{user.id}/need/#{need.id}", credentials.to_json ,request_headers
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(422)
      expect(response_body["message"]).to eq("Invalid need comment")
    end

  end
end
describe 'destroy' do
  context "Positive Case" do
    it "should delete need comment" do
      comment = FactoryGirl.create(:need_comment,body_description:"Mysore city clean", user_id: user.id,need_id: need.id)

      delete "/api/v1/users/#{user.id}/needs/#{need.id}/need_comment/#{need_comment.id}", comment.to_json,request_headers

      expect(response.status).to eq(200)
      response_body = JSON.parse(response.body)
      expect(Comment.count).to eq(0)
      expect(response_body.keys).to eq(["data", "message", "status"])
      expect(response_body["message"]).to eq(" Need Comment has been deleted successfully")
    end
  end


  context "Negative cases" do
    it "should show proper error message if it fails to find the need comment with the id passed" do
      comment = FactoryGirl.create(:need_comment,body_description:"Mysore city clean", user_id: user.id,need_id: need.id)
      delete "/api/v1/users/#{user.id}/needs/#{need.id}/need_comment/9999", {}
      expect(response.status).to eq(422)
      response_body = JSON.parse(response.body)
      expect(response_body.keys).to eq(["data", "message"])
      message = response_body["message"]
      expect(message).to eq(" Sorry !could not delete the need comment ")
    end

    it "should show proper error message if it fails to find the need with the id passed" do
      comment = FactoryGirl.create(:need_comment, user_id: user.id ,need_id: need.id)
      delete "/api/v1/users/#{user.id}/needs/9999/need_comment/#{need_comment.id}", {}
      expect(response.status).to eq(404)
      response_body = JSON.parse(response.body)
      expect(response_body.keys).to eq(["message"])
      message = response_body["message"]
      expect(message).to eq("Need not found")
    end

  end
end

end
