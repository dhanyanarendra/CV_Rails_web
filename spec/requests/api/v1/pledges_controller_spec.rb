require 'rails_helper'

RSpec.describe Api::V1::PledgesController, :type => :request do

	let!(:describe) {FactoryGirl.create(:describe)}
	let!(:goal) {FactoryGirl.create(:goal, describe_id:describe.id, title:"need")}
	let!(:task) {FactoryGirl.create(:task, goal_id:goal.id, title:"title_1")}
	let(:need) {FactoryGirl.create(:need, task_id:task.id)}
	let(:user) {FactoryGirl.create(:user)}
	let(:pledge) {FactoryGirl.create(:pledge, need_id: need.id,user_contributor_id: user.id)}


	let(:request_headers) {
		{
			"Accept" => "application/json",
			"Content-Type" => "application/json",
			"Authorization" => user.auth_token
		}
	}

	context "post" do
			it "should pledge the project" do
				pledge_params =  {"pledge" =>
					{
						"quantity" => 1,
						"pledged" => true
					}
				}
				post "/api/v1/tasks/#{task.id}d/needs/#{need.id}/pledge", pledge_params.to_json,request_headers
				expect(response.status).to eq(200)
				response_body =JSON.parse(response.body)
			end

			it "should unpledge the project" do
				pledge_params =  {"pledge" =>
					{
						"quantity" => 1,
						"pledged" => false
					}
				}
				pledge
				post "/api/v1/tasks/#{task.id}d/needs/#{need.id}/pledge", pledge_params.to_json,request_headers
				expect(response.status).to eq(200)
				response_body =JSON.parse(response.body)
			end

        context "user_contributions" do
        context "Positive case" do
        it "should list the number of pledges" do
        user = FactoryGirl.create(:user)
        pledge_params =  {"pledge" =>
          {
            "quantity" => 1,
            "pledged" => true
          }
        }
        post "/api/v1/tasks/#{task.id}d/needs/#{need.id}/pledge", pledge_params.to_json,request_headers
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(Pledge.count).to eq(1)
      end
    end
  end
	end
end
