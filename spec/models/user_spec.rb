require "rails_helper"

RSpec.describe User, type: :model do
  subject { User.new(uid: "123", screen_name: "screen_name", token: "token", secret: "secret") }

  describe "#uid" do
    it "is required" do
      subject.uid = nil
      subject.valid?
      expect(subject.errors.full_messages.first).to eq("Uid can't be blank")
    end
  end

  describe "#screen_name" do
    it "is required" do
      subject.screen_name = nil
      subject.valid?
      expect(subject.errors.full_messages.first).to eq("Screen name can't be blank")
    end
  end

  describe "#token" do
    it "is required" do
      subject.token = nil
      subject.valid?
      expect(subject.errors.full_messages.first).to eq("Token can't be blank")
    end
  end

  describe "#secret" do
    it "is required" do
      subject.secret = nil
      subject.valid?
      expect(subject.errors.full_messages.first).to eq("Secret can't be blank")
    end
  end
end