require 'rails_helper'

RSpec.describe Api::V1::NeedsController, :type => :request do

  let!(:describe) {FactoryGirl.create(:describe)}
  let!(:goal) {FactoryGirl.create(:goal, describe_id:describe.id, title:"need")}
  let!(:task) {FactoryGirl.create(:task, goal_id:goal.id, title:"title_1")}
  let(:need) {FactoryGirl.create(:need, task_id:task.id)}
  let(:user) {FactoryGirl.create(:user)}
  let(:task_suggestion) {FactoryGirl.create(:task_suggestion)}



  let(:request_headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => user.auth_token
    }
  }
  context "index" do
    context "Positive case" do
      it "should list the needs" do
        need1 = FactoryGirl.create(:need, task_id:task.id, need_name:"need_name_1")
        need2 = FactoryGirl.create(:need, task_id:task.id, need_name:"need_name_2")
        need3 = FactoryGirl.create(:need, task_id:task.id, need_name:"need_name_3")
        need = Need.order(updated_at: :desc).first
        get "/api/v1/describes/#{describe.id}/goals/#{goal.id}/tasks/#{task.id}/needs",request_headers
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["data"].size).to eq(3)
        expect(response_body["data"].first.keys).to eq(["id", "quantity", "unit", "need_decription", "created_at", "updated_at", "task_id", "need_name", "need_type", "priority", "task_suggestion_id", "checked"])
        expect(response_body["data"].first["need_name"]).to eq(need1.need_name)
        expect(response_body["data"].first["task_id"]).to eq(need.task_id)
      end
    end
  end


  context "suggestion_index" do
    context "Positive case" do
      it "should list the suggestion needs" do
        task_suggestion = FactoryGirl.create(:task_suggestion)
        need = FactoryGirl.create(:need, task_suggestion_id:task_suggestion.id, need_name:"need_name_1")
        get "/api/v1/#{task_suggestion.id}/suggestion_needs", {}, request_headers
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["data"].first.keys).to eq(["id", "quantity", "unit", "need_decription", "created_at", "updated_at", "task_id", "need_name", "need_type", "priority", "task_suggestion_id", "checked"])
      end
    end
  end

  describe 'create' do
    context "Positive case" do
      it "should create a need" do
        need = FactoryGirl.create(:need, task_id:task.id, need_name:"need_name_1")
        need_params = need.as_json
        post "/api/v1/describes/#{describe.id}/goals/#{goal.id}/tasks/#{task.id}/needs", need_params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["data", "message", "status"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Need has been successfully created")
      end
    end
  end

  describe 'suggestion_need' do
    context "Positive case" do
      it "should create a suggestion need" do
        need = FactoryGirl.create(:need, need_name:"need_name_1", task_suggestion_id:task_suggestion.id)
        need_params = need.as_json
        post "/api/v1/suggestion_need/#{task_suggestion.id}", need_params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["data", "message", "status"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Suggestion Need has been successfully created")
      end
    end
  end


 describe 'checked_needs' do
    context "Positive case" do
      it "should check the needs checkbox" do
        need = FactoryGirl.create(:need, checked:"true", task_suggestion_id:task_suggestion.id)
        need_params = need.as_json
        post "/api/v1/checked_needs/#{need.id}", need_params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["data"])
        data = response_body["data"]
      end
    end
  end

   describe 'checked_needs' do
    context "Negative case" do
      it "should not check the needs checkbox" do
        post "/api/v1/checked_needs/9999", {}
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(404)
        expect(response_body.keys).to eq(["message"])
        data = response_body["message"]
        expect(response_body["message"]).to eq("Needs not checked")
      end
    end
  end



  describe "show" do
    context "Positive case" do
      it "should show need based on need id " do
        get "/api/v1/describes/#{describe.id}/goals/#{goal.id}/tasks/#{task.id}/needs/#{need.id}"
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["message"]).to eq("need found")
      end
    end

    describe "Negative case" do
      it "should throw an error when need is fetched with invalid ID" do
        get "/api/v1/describes/#{describe.id}/goals/#{goal.id}/tasks/#{task.id}/needs/12345"
        expect(response.status).to eq(422)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["message"])
        message = response_body["message"]
        expect(message).to eq("need not found")
      end
    end
  end

  describe "update" do
    context "Positive Case" do
      it "should update the need details" do
        need = FactoryGirl.create(:need, task_id:task.id, need_name:"need_name_1")
        need_params = need.as_json
        need_params[:need_name] = "cleaning mysore"
        put "/api/v1/describes/#{describe.id}/goals/#{goal.id}/tasks/#{task.id}/needs/#{need.id}", need_params
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["data", "message", "status" ])
        expect(response_body["data"]["need_name"]).to eq("cleaning mysore")
        expect(response_body["message"]).to eq("Need has been updated successfully")
      end
    end
  end


  describe "suggestion_need_update" do
    context "Positive Case" do
      it "should update the suggestion need details" do
        need = FactoryGirl.create(:need, task_suggestion_id:task_suggestion.id, need_name:"need_name_1")
        need_params = need.as_json
        need_params[:need_name] = "cleaning mysore"
        put "/api/v1/#{task_suggestion.id}/suggestion_needs/#{need.id}", need_params
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["data", "message", "status" ])
        expect(response_body["data"]["need_name"]).to eq("cleaning mysore")
        expect(response_body["message"]).to eq("Suggestion Need has been updated successfully")
      end
    end
  end
  describe "destroy" do
    context "Positive cases" do
      it "should delete a need" do
       need = FactoryGirl.create(:need, task_id:task.id, need_name:"need_name_1")
       delete "/api/v1/describes/#{describe.id}/goals/#{goal.id}/tasks/#{task.id}/needs/#{need.id}", {}
       expect(response.status).to eq(200)
       response_body = JSON.parse(response.body)
       expect(Need.count).to eq(0)
       expect(response_body.keys).to eq(["data", "message", "status"])
       expect(response_body["message"]).to eq("Need has been deleted successfully")
     end
   end

   context "Negative cases" do
    it "should show proper error message if it fails to find the need with the id passed" do
      need = FactoryGirl.create(:need, task_id:task.id, need_name:"need_name_1")
      delete "/api/v1/describes/#{describe.id}/goals/#{goal.id}/tasks/#{task.id}/needs/9999", {}
      expect(response.status).to eq(422)
      response_body = JSON.parse(response.body)
      expect(response_body.keys).to eq(["data", "message"])
      message = response_body["message"]
      expect(message).to eq(" Sorry !could not delete the Need ")
      end
    end
  end

  describe "suggestion_need_destroy" do
    context "Positive cases" do
      it "should delete a Suggestion_need" do
       need = FactoryGirl.create(:need, task_suggestion_id:task_suggestion.id, need_name:"need_name_1")
       delete "/api/v1/#{task_suggestion.id}/suggestion_needs/#{need.id}", {}
       expect(response.status).to eq(200)
       response_body = JSON.parse(response.body)
       expect(Need.count).to eq(0)
       expect(response_body.keys).to eq(["data", "message", "status"])
       expect(response_body["message"]).to eq(" Suggestion Need has been deleted successfully")
     end
   end

   context "Negative cases" do
    it "should show proper error message if it fails to find the Suggestion_need with the id passed" do
      need = FactoryGirl.create(:need, task_id:task.id, need_name:"need_name_1")
      delete "/api/v1/#{task_suggestion.id}/suggestion_needs/9999", {}
      expect(response.status).to eq(422)
      response_body = JSON.parse(response.body)
      expect(response_body.keys).to eq(["data", "message"])
      message = response_body["message"]
      expect(message).to eq(" Sorry !could not delete the  Suggestion Need ")
      end
    end
  end
end