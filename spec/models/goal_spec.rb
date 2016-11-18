require 'rails_helper'

RSpec.describe Goal, type: :model do
	context "Factory" do
		it "should validate all the goal" do
			expect(FactoryGirl.build(:goal).valid?).to be true
		end
	end

  describe 'Associations' do
    it { should belong_to :describe }
    it { should have_many :tasks }
  end

	context "Validations" do
		it {should validate_presence_of :title}
	end
end
