require 'rails_helper'

RSpec.describe User, type: :model do
	let!(:user) {FactoryGirl.build(:user)}
	context "Factory" do
		it "should validate all the user" do
			expect(FactoryGirl.build(:user).valid?).to be true
		end
	end

	describe 'Associations' do
    it { should have_many :describes }
    it { should have_many :pledges }
  end

	context "Validations" do
		it {should validate_presence_of :user_name }
		it {should validate_presence_of :email }
		it {should validate_presence_of :password }
		it {should validate_length_of(:password).is_at_least(8)}
		it {should validate_length_of(:user_name).is_at_least(8)}

	end

	context "Instance Methods" do
		it "generate_auth_token" do
			user = FactoryGirl.build(:user)
			expect(user.auth_token).to be_nil
			user.generate_auth_token
			expect(user.auth_token).to_not be_nil
		end
		it "should generate_password_reset_token" do
			Timecop.freeze
			user = FactoryGirl.build(:user)
			user.generate_password_reset_token
			expect(user.password_reset_token).to_not be_nil
			expect(user.password_reset_sent_at).to eq(Time.current)
		end
	end



end
