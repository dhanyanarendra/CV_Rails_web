require 'rails_helper'
require 'base64'

RSpec.describe Api::V1::DescribesController, :type => :request do

  let(:user) {FactoryGirl.create(:user)}
  let(:describe) {FactoryGirl.create(:describe, :user => user)}
  let(:goal) {FactoryGirl.create(:goal,:describe_id => describe.id)}
  let(:task) {FactoryGirl.create(:task, :goal_id => goal.id)}
  let(:need) {FactoryGirl.create(:need,:task_id => task.id)}
  let(:pledge) {FactoryGirl.create(:pledge,:user_contributor_id => user.id, :need_id => need.id)}
  let(:pledge1) {FactoryGirl.create(:pledge,:user_contributor_id => user.id,:need_id => need.id)}
  let(:pledge2) {FactoryGirl.create(:pledge,:user_contributor_id => user.id,:need_id => need.id)}


  let(:request_headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => user.auth_token
    }
  }

  context "index" do
    context "Positive case" do
      it "should list all projects" do
        1.times {FactoryGirl.create(:describe, :user_originator_id=> user.id, :published => true)}
        describe = Describe.order(updated_at: :desc).first
        get "/api/v1/describes",{},request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["data"].size).to eq(1)
        # expect(response_body["data"].first.keys).to eq(["id", "title", "category", "short_description", "background", "impact", "need", "risks", "others", "created_at", "updated_at", "name", "file", "user_originator_id", "published", "likes", "follows", "user_like", "user_follow"])
        expect(response_body["data"].first["title"]).to eq(describe.title)
        expect(response_body["data"].first["category"]).to eq(describe.category)
        expect(response_body["data"].first["short_description"]).to eq(describe.short_description)
        expect(response_body["data"].first["background"]).to eq(describe.background)
        expect(response_body["data"].first["impact"]).to eq(describe.impact)
        expect(response_body["data"].first["need"]).to eq(describe.need)
        expect(response_body["data"].first["risks"]).to eq(describe.risks)
        expect(response_body["data"].first["others"]).to eq(describe.others)
        expect(response_body["data"].first["name"]).to eq(describe.name)

      end
    end
  end

  it "should search all the string fields" do
    describe = FactoryGirl.create(:describe, :title => "title1", :category =>  "All Categories", :user_originator_id=> user.id, :published => true)
    describe = FactoryGirl.create(:describe,:title => "title1",  :category =>  "Community", :user_originator_id=> user.id, :published => true)
    describe = FactoryGirl.create(:describe, :title => "title3", :category =>  "All Categories", :user_originator_id=> user.id, :published => true)
    describe = FactoryGirl.create(:describe, :title => "title4", :category =>  "Community", :user_originator_id=> user.id, :published => true)

    describe = Describe.order(created_at: :desc)

    post "/api/v1/search", {query: {title: "title1",category: "All Categories"}}.to_json, request_headers
    expect(response.code).to eq("200")
    body = JSON.parse(response.body)
    expect(body['data'].size).to eq(2)
    expect(body['data'][0]["title"]).to eq("title1")

    post "/api/v1/search", {query: {title: "title1",category:  "Community"}}.to_json, request_headers
    expect(response.code).to eq("200")
    body = JSON.parse(response.body)
    expect(body['data'].size).to eq(1)
    expect(body['data'][0]["title"]).to eq("title1")

    post "/api/v1/search", {query: {title: "title4",category:  "All Categories"}}.to_json, request_headers
    expect(response.code).to eq("200")
    body = JSON.parse(response.body)
    expect(body['data'].size).to eq(1)
    expect(body['data'][0]["title"]).to eq("title4")

  end


  context "publish_user" do
    context "Positive case" do
      it "should list the projects" do
        user = FactoryGirl.create(:user)
        describe = FactoryGirl.create(:describe)
        get "/api/v1/#{user.id}/user_publish", {}, request_headers
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(Describe.count).to eq(1)
      end
    end
  end


  context "pledge_name" do
    context "Positive case" do
      it "should list all the pledged users of a particular need" do
        get "/api/v1/#{need.id}/pledged_user" ,{},request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("List of pledged users")
      end
    end
  end

  context "Negative case" do
    it "should not list all the pledged users of a particular need" do
      get "/api/v1/12324/pledged_user",{},request_headers
      expect(response.status).to eq(422)
      response_body = JSON.parse(response.body)
      data = response_body["data"]
      message = response_body["message"]
      expect(message).to eq("No Pledged user found")
    end
  end

  context "show" do
    context "Positive case" do
      it "should show project based on project id " do
        get "/api/v1/describes/#{describe.id}" ,{},request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["message"]).to eq("Project found")
      end
    end

    context "Negative case" do
      it "should throw an error when project is fetched with invalid ID" do
        get "/api/v1/describes/1234" ,{},request_headers
        expect(response.status).to eq(422)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["message"])
        message = response_body["message"]
        expect(message).to eq("Invalid project ID")
      end
    end
  end

  context "like_project" do
    context "Positive case" do
      it "should like project based on project id " do
        like_params = {like: true}
        post "/api/v1/#{describe.id}/describe/like", like_params.to_json ,request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["message"]).to eq("Like")
      end
    end
  end


  context "like_project" do
    context "positive case" do
      it "should unlike project based on project id " do
        unlike_params = {like: false}
        post "/api/v1/#{describe.id}/describe/like",unlike_params.to_json ,request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["message"]).to eq("Unlike")
      end
    end
  end

  context "show" do
    context "Positive case" do
      it "should list the projects " do
        get "/api/v1/dashboard_projects" ,{},request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["message"]).to eq("Projects list")
      end
    end
  end

  context "List pledges" do
    context "Positive case" do
      it "should list the Pledges " do
        [pledge,pledge1,pledge2]
        get "/api/v1/my_pledges" ,{},request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["message"]).to eq("Pledges list")
      end
    end
  end

  context "List Pledges" do
    context "Negative case" do
      it "should not list the Pledges" do
        get "/api/v1/my_pledges" ,{},request_headers
        expect(response.status).to eq(200)
        response_body =JSON.parse(response.body)
        expect(response_body["message"]).to eq("No Pledges found")
      end
    end
  end

  context "fetch_project_details" do
    it "should provide all the details of a particular project" do
      get "/api/v1/#{describe.id}/fetch_project_details" ,{},request_headers
      expect(response.status).to eq(200)
      response_body =JSON.parse(response.body)
      expect(response_body["message"]).to eq("Successfully listed all the details of the projects")
    end
  end



  # context "follow_project" do
  #   context "Positive case" do
  #     it "should like project based on project id " do
  #       follow_params = {follow: true}
  #       post "/api/v1/#{describe.id}/describe/follow", follow_params.to_json ,request_headers
  #       expect(response.status).to eq(200)
  #       response_body =JSON.parse(response.body)
  #       expect(response_body["message"]).to eq("Follow")
  #     end
  #   end
  # end


  # context "follow_project" do
  #   context "positive case" do
  #     it "should unfollow project based on project id " do
  #       unfollow_params = {unfollow: false}
  #       post "/api/v1/#{describe.id}/describe/follow",unfollow_params.to_json ,request_headers
  #       expect(response.status).to eq(200)
  #       response_body =JSON.parse(response.body)
  #       expect(response_body["message"]).to eq("Unfollow")
  #     end
  #   end
  # end


  describe 'create' do
    context "Positive case" do
      it "should create a describe" do
        file = {}
        file[:data] = Base64.encode64(File.open(File.join(Rails.root,'/spec/fixtures/download.jpg')).read)
        credentials = {describe: {title: "New Clean City",category: describe.category,short_description: describe.short_description, background: describe.background , impact: describe.impact, need: describe.need, risks: describe.risks, others: describe.others,name: describe.name,file: file}}
        post "/api/v1/describes", credentials.to_json, request_headers
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response_body.keys).to eq(["message", "data", "status"])
        data = response_body["data"]
        message = response_body["message"]
        expect(message).to eq("Successfully created describes")
      end
    end

    context "Negative case" do
      it "should throw error without params" do
        credentials = {describe: {}}
        post "/api/v1/describes", credentials ,request_headers
        response_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response_body["message"]).to eq("Fill the empty fields")
      end

    end
  end

  describe "update" do
    context "Positive Case" do
      it "should update the project details" do
        describe = FactoryGirl.create(:describe)
        describe_params = describe.as_json
        describe_params[:title] = "cleaning bangalore"
        describe_params[:category] = "land"
        describe_params[:short_description] = "environment"

        put "/api/v1/describes/#{describe.id}",describe_params.to_json,request_headers
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["data", "message", "status" ])
        expect(response_body["data"]["title"]).to eq("cleaning bangalore")
        expect(response_body["data"]["category"]).to eq("land")
        expect(response_body["message"]).to eq("Project has been updated successfully")
      end
    end

    context "Negative cases" do
      it "should show proper error message if it fails to find the project with the id passed" do
        put "/api/v1/describes/9999", {}
        expect(response.status).to eq(422)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["message"])
        message = response_body["message"]
        expect(message).to eq("Project not found")
      end



      it "should show proper error message if the fields are empty" do
        describe_params = describe.as_json
        describe_params[:title] = ""
        describe_params[:category] = ""
        describe_params[:short_description] = ""

        put "/api/v1/describes/#{describe.id}",describe_params.to_json,request_headers
        expect(response.status).to eq(422)
        response_body = JSON.parse(response.body)
        expect(response_body.keys).to eq(["error", "message"])
        message = response_body["message"]
        expect(message).to eq("Please fill the empty fields")

      end

    end
  end

  describe "delete" do

    context"Positive case" do
      it "should delete projects of current user based on Id" do
        delete "/api/v1/describes/#{describe.id}",{},request_headers
        expect(response.status).to eq(200)
        response_body=JSON.parse(response.body)
        expect(response_body.keys).to eq(["message", "status"])
        message = response_body["message"]
        expect(message).to eq("Successfully deleted project")
      end
    end

    context "Negative Case"do
    it "should throw error if project doesn't exist" do
      delete "/api/v1/describes/9999",{},request_headers
      expect(response.status).to eq(422)
      response_body=JSON.parse(response.body)
      expect(response_body.keys).to eq(["message"])
      message = response_body["message"]
      expect(message).to eq("Invalid project ID")
    end
  end
end

describe "List Followed projects" do
  context "positive case" do
    it "should list all the projects that current user follows" do
      get "/api/v1/show_all_followed_projects",{},request_headers
      expect(response.status).to eq(200)
      response_body=JSON.parse(response.body)
      expect(response_body.keys).to eq(["message", "data", "status" ])
      data = response_body["data"]
      expect(response_body["message"]).to eq("Successfully listed all the projects followed by the current user.")
    end
  end

  context "Negative case" do
    it "should throw error when there is no current user" do
      get "/api/v1/show_all_followed_projects"
      expect(response.status).to eq(422)
      response_body=JSON.parse(response.body)
      expect(response_body.keys).to eq(["message"])
      expect(response_body["message"]).to eq("User not found.")
    end
  end
end
end
