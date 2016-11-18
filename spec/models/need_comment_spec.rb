require 'rails_helper'

RSpec.describe NeedComment, type: :model do
  let!(:need_comment) {FactoryGirl.build(:need_comment)}


  context "Factory" do
    it "should validate all the comment" do
      expect(FactoryGirl.build(:need_comment).valid?).to be true
    end
  end

  describe 'Associations' do
    it { should belong_to :user }
    it { should belong_to :need }

  end

  context "Validations" do
    it {should validate_presence_of :body_description }
  end


end
