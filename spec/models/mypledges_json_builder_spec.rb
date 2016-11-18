require 'rails_helper'

RSpec.describe MypledgesJsonBuilder, type: :model do
  let(:user) {FactoryGirl.create(:user)}
  let(:describe) {FactoryGirl.create(:describe, :user => user)}
  let(:goal) {FactoryGirl.create(:goal,:describe_id => describe.id)}
  let(:task) {FactoryGirl.create(:task, :goal_id => goal.id)}
  let(:need) {FactoryGirl.create(:need,:task_id => task.id)}
  let(:pledge) {FactoryGirl.create(:pledge,:user_contributor_id => user.id, :need_id => need.id)}
  let(:pledge1) {FactoryGirl.create(:pledge,:user_contributor_id => user.id,:need_id => need.id)}
  let(:pledge2) {FactoryGirl.create(:pledge,:user_contributor_id => user.id,:need_id => need.id)}

  context "Factory" do
    it "should list all the pledges" do
      pledges = [pledge,pledge1,pledge2]
      response = MypledgesJsonBuilder.new(user).build_comment(pledges)
      expect(response.count).to eq(pledges.count)
    end
  end

   context "Factory" do
    it "should list all the pledges" do
      pledges = []
      response = MypledgesJsonBuilder.new(user).build_comment(pledges)
      expect(response).to eq([])
    end
  end
end
