require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:task) {FactoryGirl.build(:task)}
  context "Factory" do
    it "should validate all the task" do
      expect(FactoryGirl.build(:task).valid?).to be true
    end
  end

  describe 'Associations' do
    it { should belong_to :goal }
    it { should have_many :needs }
  end

  context "Validations" do
    it {should validate_presence_of :title}
  end
end
