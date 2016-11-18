require 'rails_helper'
RSpec.describe Describe, type: :model do

	let!(:describe) {FactoryGirl.build(:describe)}

	context "Factory" do
		it "should validate all the describe" do
			expect(FactoryGirl.build(:describe).valid?).to be true
		end
	end

	describe 'Associations' do
    it { should belong_to :user }
    it { should have_many :goals }
    it { should have_many :likes }
    it { should have_many :follows }
    it { should have_many :task_suggestions }

  end

	context "Validations" do
		it {should validate_presence_of :title }
		it {should validate_presence_of :category }
		it {should validate_length_of(:short_description).is_at_most(140)}
    it {should validate_presence_of :short_description}
	end
end
