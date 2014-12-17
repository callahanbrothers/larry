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

  describe ".find_or_create" do
    context "when a user already exists" do
      before do
        allow(User).to receive(:find_by).and_return("pre-existing user")
      end

      it "returns the user with the passed in UID" do
        expect(User.find_or_create("123", "screen_name", "token", "secret")).to eq("pre-existing user")
      end
    end

    context "when the user does not exist" do
      before do
        allow(User).to receive(:find_by).and_return(nil)
      end

      it "creates a user with the passed in UID, screen_name, token, and secret" do
        expect{User.find_or_create("123", "screen_name", "token", "secret")}.to change(User, :count).by(1)
      end

      it "returns the newly created user" do
        allow(User).to receive(:create).and_return("new user")

        expect(User.find_or_create("123", "screen_name", "token", "secret")).to eq("new user")
      end
    end

  end
end