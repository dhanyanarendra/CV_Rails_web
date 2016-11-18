require 'rails_helper'

RSpec.describe PledgeJsonBuilder, type: :model do
  let(:user) {FactoryGirl.create(:user)}
  let(:task) {FactoryGirl.create(:task)}
  let(:need) {FactoryGirl.create(:need, :task_id => task.id)}
  let(:pledge) {FactoryGirl.create(:pledge, :need_id => need.id, :user_contributor_id => user.id)}
  let(:pledge1) {FactoryGirl.create(:pledge,:need_id => need.id)}
  let(:pledge2) {FactoryGirl.create(:pledge,:need_id => need.id)}

  context "Factory" do
    it "should list all the pledged users" do
      pledges = [pledge,pledge1,pledge2]
      response = PledgeJsonBuilder.new([pledge,pledge1,pledge2],user).build_pledge
      expect(response.count).to eq(pledges.count)
    end
  end

   context "Factory" do
    it "should list all the pledged users" do
      pledges = []
      response = PledgeJsonBuilder.new([],user).build_pledge
      expect(response).to eq([])
    end
  end
end
