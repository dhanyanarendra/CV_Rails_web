require 'rails_helper'

RSpec.describe Pledge, type: :model do
  let(:pledge){FactoryGirl.create(:pledge)}

  context "Factory settings for needs" do
    it "should validate the need factories" do
      expect(FactoryGirl.build(:pledge).valid?).to be true
    end

    describe 'Associations' do
      it { should belong_to :user }
      it { should belong_to :need }
    end
  end
end
