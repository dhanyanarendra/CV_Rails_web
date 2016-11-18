require 'rails_helper'

RSpec.describe Api::V1::TasksController, :type => :request do

  let(:describe) {FactoryGirl.create(:describe)}
  let(:goal) {FactoryGirl.create(:goal,:describe_id => describe.id)}
  let(:task) {FactoryGirl.create(:task, :goal_id => goal.id)}

  context "index" do
    context "Positive case" do
      it "should list the tasks" do
        describe1 = FactoryGirl.create(:describe)
        goal1 = FactoryGirl.create(:goal, describe_id:describe1.id, title:"title_1")
        task1 = FactoryGirl.create(:task, goal_id:goal1.id, title:"title_1")
        task2 = FactoryGirl.create(:task, goal_id:goal1.id, title:"title_2")
        task3 = FactoryGirl.create(:task, goal_id:goal1.id, title:"title_3")

        task = Task.order(updated_at: :desc).first

        get "/api/v1/describes/#{describe1.id}/goals/#{goal1.id}/tasks", {}
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["data"].size).to eq(3)
        expect(response_body["data"].first.keys).to eq(["id", "goal_id", "title", "created_at", "updated_at", "date", "time", "description", "venue", "timezone", "task_suggestion_id", "priority", "status"])
        expect(response_body["data"].first["title"]).to eq(task1.title)
        expect(response_body["data"].first["goal_id"]).to eq(task1.goal_id)
        expect(response_body["data"].first["date"]).to eq(task1.date)
        expect(response_body["data"].first["time"]).to eq(task1.time)
        expect(response_body["data"].first["venue"]).to eq(task1.venue)
        expect(response_body["data"].first["description"]).to eq(task1.description)
      end
    end
  end

  describe 'create' do
    context "Positive case" do
      it "should create a user" do
        describe1 = FactoryGirl.create(:describe)
        goal1 = FactoryGirl.create(:goal, describe_id:describe1.id, title:"title_1")
        task = FactoryGirl.create(:task, goal_id:goal1.id, title:"title_1")
        task_params = task.as_json

        post "/api/v1/describes/#{describe1.id}/goals/#{goal1.id}/tasks", task_params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["data", "message", "status"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Task has been successfully created")
      end
    end


    context "Negative case" do
      it "should throw error without params" do
        describe1 = FactoryGirl.create(:describe)
        goal1 = FactoryGirl.create(:goal, describe_id:describe1.id, title:"title_1")
        post "/api/v1/describes/#{describe1.id}/goals/#{goal1.id}/tasks",{}
        response_body = JSON.parse(response.body)
        expect(response_body["status"]).to eq(422)
        expect(response_body["message"]).to eq("Fill the empty fields")
      end
    end
  end

  describe "show" do
    context "Positive case" do
      it "should show task based on task id " do
        get "/api/v1/describes/#{describe.id}/goals/#{goal.id}/tasks/#{task.id}"
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["message"]).to eq("Task found")
      end
    end

    describe "Negative case" do
      it "should throw an error when task is fetched with invalid ID" do
        get "/api/v1/describes/#{describe.id}/goals/#{goal.id}/tasks/12354"
        expect(response.status).to eq(422)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["message"])
        message = response_body["message"]
        expect(message).to eq("task not found")
      end
    end
  end



  describe "update" do
    context "Positive Case" do
      it "should update the task details" do
        describe2 = FactoryGirl.create(:describe)
        goal2 = FactoryGirl.create(:goal, describe_id:describe2.id, title:"title_1")
        task = FactoryGirl.create(:task, goal_id:goal2.id, title:"title_1", date:"2016-05-16", time:"05:12", timezone: "UTC")
        task_params = task.as_json
        task_params[:title] = "cleaning mysore"
        task_params[:date] = "2016-02-09"
        task_params[:time] = "04:15"
        task_params[:description] = "environment"


        put "/api/v1/describes/#{describe2.id}/goals/#{goal2.id}/tasks/#{task.id}", task_params
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["data", "message", "status" ])
        expect(response_body["data"]["title"]).to eq("cleaning mysore")
        expect(response_body["data"]["date"]).to eq("2016-02-09")
        expect(response_body["message"]).to eq("Task has been updated successfully")
      end
    end
  end

  describe "destroy" do
    context "Positive cases" do
      it "should delete a task" do
       describe3 = FactoryGirl.create(:describe)
       goal3 = FactoryGirl.create(:goal, describe_id:describe3.id, title:"title_1")
       task = FactoryGirl.create(:task, goal_id:goal3.id, title:"title_1")

       delete "/api/v1/describes/#{describe3.id}/goals/#{goal3.id}/tasks/#{task.id}", {}

       expect(response.status).to eq(200)
       response_body = JSON.parse(response.body)
       expect(Task.count).to eq(0)
       expect(response_body.keys).to eq(["data", "message", "status"])
       expect(response_body["message"]).to eq("Task has been deleted successfully")
     end
   end
   context "Negative cases" do
    it "should show proper error message if it fails to find the task with the id passed" do
      describe3 = FactoryGirl.create(:describe)
      goal3 = FactoryGirl.create(:goal, describe_id:describe3.id, title:"title_1")
      task = FactoryGirl.create(:task, goal_id:goal3.id, title:"title_1")

      delete "/api/v1/describes/#{describe3.id}/goals/#{goal3.id}/tasks/9999", {}

      expect(response.status).to eq(422)
      response_body = JSON.parse(response.body)
      expect(response_body.keys).to eq(["data", "message"])

      message = response_body["message"]
      expect(message).to eq(" Sorry !could not delete the task ")
    end
  end
end
end
