RSpec.describe Need, type: :model do
	let(:need){FactoryGirl.create(:need)}

	context "Factory settings for needs" do
		it "should validate the need factories" do
			expect(FactoryGirl.build(:need).valid?).to be true
		end

		describe 'Associations' do
			it { should belong_to :task }
			it { should have_many :pledges }
			it { should belong_to :task_suggestion }
		end
	end
end
