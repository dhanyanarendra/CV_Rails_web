require 'rails_helper'

RSpec.describe Api::V1::GoalsController, :type => :request do
  let!(:describe) {FactoryGirl.create(:describe)}
  let!(:goal) {FactoryGirl.create(:goal, describe_id: describe.id)}

  context "index" do
    context "Positive case" do
      it "should list the goals" do
        goal = Goal.order(updated_at: :desc).first
        get "/api/v1/describes/#{describe.id}/goals", {}
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["data"].size).to eq(1)
        expect(response_body["data"].first.keys).to eq(["id", "title", "created_at", "updated_at", "describe_id", "priority"])
        expect(response_body["data"].first["title"]).to eq(goal.title)
        expect(response_body["data"].first["describe_id"]).to eq(goal.describe_id)
      end
    end
  end

  describe 'create' do
    context "Positive case" do
      it "should create a goal" do
        goal_params = goal.as_json
        post "/api/v1/describes/#{describe.id}/goals", goal_params
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["message", "data"]
          )
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully created")
      end
    end


    context "Negative case" do
      it "should throw error without params" do
        post "/api/v1/describes/#{describe.id}/goals",{}
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body["message"]).to eq("Invalid goal")
      end
    end
  end

  describe "show" do
    context "Positive case" do
      it "should show goal based on goal id " do
        get "/api/v1/describes/#{describe.id}/goals/#{goal.id}"
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["message"]).to eq("goal found")
      end
    end

    describe "Negative case" do
      it "should throw an error when goal is fetched with invalid ID" do
        get "/api/v1/describes/#{describe.id}/goals/12324"
        expect(response.status).to eq(422)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["message"])
        message = response_body["message"]
        expect(message).to eq("Invalid goal ID")
      end
    end
  end



  describe "update" do
    context "Positive Case" do
      it "should update the goal details" do
        goal_params = goal.as_json
        goal_params[:title] = "cleaning mysore"
        put "/api/v1/describes/#{describe.id}/goals/#{goal.id}", goal_params
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["data", "message", "status" ])
        expect(response_body["data"]["title"]).to eq("cleaning mysore")
        expect(response_body["message"]).to eq("goal has been updated successfully")
      end
    end
  end


  describe "destroy" do
    context "Positive cases" do
      it "should delete a goal" do
       delete "/api/v1/describes/#{describe.id}/goals/#{goal.id}", {}
       expect(response.status).to eq(200)
       response_body = JSON.parse(response.body)
       expect(Goal.count).to eq(0)
       expect(response_body.keys).to eq(["data", "message", "status"])
       expect(response_body["message"]).to eq("goal has been deleted successfully")
     end
   end

   context "Negative cases" do
    it "should show proper error message if it fails to find the goal with the id passed" do
      delete "/api/v1/describes/#{describe.id}/goals/9999", {}
      expect(response.status).to eq(422)
      response_body = JSON.parse(response.body)
      expect(response_body.keys).to eq(["data", "message"])
      message = response_body["message"]
      expect(message).to eq(" Sorry !could not delete the goal ")
    end
  end
end
end
