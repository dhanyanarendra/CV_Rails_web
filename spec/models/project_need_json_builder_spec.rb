require 'rails_helper'

RSpec.describe ProjectNeedJsonBuilder, type: :model do
  let(:user) {FactoryGirl.create(:user)}
  let(:describe) {FactoryGirl.create(:describe, :user => user)}
  let(:goal) {FactoryGirl.create(:goal,:describe_id => describe.id)}
  let(:task) {FactoryGirl.create(:task, :goal_id => goal.id)}
  let(:need) {FactoryGirl.create(:need,:task_id => task.id)}
  let(:pledge) {FactoryGirl.create(:pledge,:user_contributor_id => user.id, :need_id => need.id)}
  let(:pledge1) {FactoryGirl.create(:pledge,:need_id => need.id)}
  let(:pledge2) {FactoryGirl.create(:pledge,:need_id => need.id)}

  context "Factory" do
    it "should list all the pledged needs" do
      needs = [need]
      response = ProjectNeedJsonBuilder.new(describe,user).build_project_needs
      expect(response.count).to eq(needs.count)
    end
  end

  context "Factory" do
    it "should list all the pledged needs" do
      needs = []
      response = ProjectNeedJsonBuilder.new(describe, user).build_project_needs
      expect(response).to eq([])
    end
  end
end

