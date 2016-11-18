require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:comment) {FactoryGirl.build(:comment)}

  context "Factory" do
    it "should validate all the comment" do
      expect(FactoryGirl.build(:comment).valid?).to be true
    end
  end

  describe 'Associations' do
    it { should belong_to :user }
    it { should belong_to :describe }

  end

  context "Validations" do
    it {should validate_presence_of :comment_body }
  end
end
