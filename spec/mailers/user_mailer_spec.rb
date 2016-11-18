require "rails_helper"

RSpec.describe UsersMailer, type: :mailer do

  describe "forgot_password" do
    let (:user) {FactoryGirl.create(:user)}
    let (:mail) { UsersMailer.forgot_password(user) }

    it "should render the headers" do
      expect(mail.subject).to eq("Reset your PeerShape password")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["info@peershape.com"])
    end

    it "should render the body" do
      expect(mail.body.encoded).to match("Hello")
    end
  end

  describe "reset_password" do
    let (:user) {FactoryGirl.create(:user)}
    let (:mail) { UsersMailer.reset_password(user,'0.0.0.0') }

    it "should render the headers" do
      expect(mail.subject).to eq("Password reset confirmation from PeerShape")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["info@peershape.com"])
    end

    it "should render the body" do
      expect(mail.body.encoded).to match("Hello")
    end

  end

end