require 'rails_helper'

RSpec.describe TaskSuggestion, type: :model do
	
	let(:task_suggestion){FactoryGirl.create(:task_suggestion)}

	context "Factory settings for task_suggestions" do
		it "should validate the task_suggestion factories" do
			expect(FactoryGirl.build(:task_suggestion).valid?).to be true
		end
	end

	describe 'Associations' do
		it { should belong_to :describe }
		it { should have_many :needs }
	end 
end
