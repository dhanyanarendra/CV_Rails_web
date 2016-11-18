require 'rails_helper'

RSpec.describe Api::V1::SuggestionTasksController, :type => :request do

  let(:describe) {FactoryGirl.create(:describe)}
  let(:task_suggestion) {FactoryGirl.create(:task_suggestion)}
  let(:user) {FactoryGirl.create(:user)}



  let(:request_headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => user.auth_token
    }
  }

  context "like_suggestiontask" do
    context "Positive case" do
      it "should like task based on task id " do
        like_params = {like: true}
        post "/api/v1/#{task_suggestion.id}/task_suggestion/like", like_params.to_json ,request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["message"]).to eq("Like")
      end
      it "should unlike task based on task id " do
        unlike_params = {like: false}
        post "/api/v1/#{task_suggestion.id}/task_suggestion/like",unlike_params.to_json ,request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["message"]).to eq("Unlike")
      end
    end
  end

  context "index" do
    context "Positive case" do
      it "should list the tasks" do
        describe = FactoryGirl.create(:describe)
        task_suggestion = FactoryGirl.create(:task_suggestion, suggestion_title:"title_1",describe_id:describe.id)
        get "/api/v1/#{describe.id}/suggestion_tasks", {}, request_headers
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["data"].first.keys).to eq(["id", "suggestion_title", "date", "time", "description", "venue", "timezone", "user_id", "created_at", "updated_at", "describe_id", "suggestion_status", "likes", "needs"])
      end
    end
  end

    context "profile_index" do
    context "Positive case" do
      it "should list the tasks" do
        user = FactoryGirl.create(:user)
        task_suggestion = FactoryGirl.create(:task_suggestion, suggestion_title:"title_1")
        get "/api/v1/#{user.id}/profile_index", {}, request_headers
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(TaskSuggestion.count).to eq(1)
      end
    end
  end


  describe 'create' do
    context "Positive case" do
      it "should create a task_suggestion" do
        describe = FactoryGirl.create(:describe)
        task_suggestion = FactoryGirl.create(:task_suggestion, suggestion_title:"title_1", describe_id:describe.id)
        task_suggestion_params = task_suggestion.as_json
        post "/api/v1/#{describe.id}/suggestion_tasks", task_suggestion_params.to_json,request_headers
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["data", "message", "status"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Suggestion Task has been successfully created")
      end
    end


    context "Negative case" do
      it "should throw error without params" do
        describe = FactoryGirl.create(:describe)
        post "/api/v1/#{describe.id}/suggestion_tasks", {},request_headers
        response_body = JSON.parse(response.body)
        expect(response_body["status"]).to eq(422)
        expect(response_body["message"]).to eq("Fill the empty fields")
      end
    end
  end

  describe "destroy" do
    context "Positive cases" do
      it "should delete a task" do
       describe = FactoryGirl.create(:describe)
       task_suggestion = FactoryGirl.create(:task_suggestion, suggestion_title:"title_1", describe_id:describe.id,user_id:user.id)
       delete "/api/v1/suggestion_tasks/#{task_suggestion.id}", {},request_headers
       expect(response.status).to eq(200)
       response_body = JSON.parse(response.body)
       expect(Task.count).to eq(0)
       expect(response_body.keys).to eq(["data", "message", "status"])
       expect(response_body["message"]).to eq("Suggestion task_suggestion has been deleted successfully")
     end
   end

   context "Negative cases" do
    it "should show proper error message if it fails to find the task with the id passed" do
      describe = FactoryGirl.create(:describe)
      task_suggestion = FactoryGirl.create(:task_suggestion, suggestion_title:"title_1")
      delete "/api/v1/suggestion_tasks/07", {},request_headers
      expect(response.status).to eq(422)
      response_body = JSON.parse(response.body)
      expect(response_body.keys).to eq(["data", "message"])

      message = response_body["message"]
      expect(message).to eq("Task Suggestion not found")
    end
  end
end
end