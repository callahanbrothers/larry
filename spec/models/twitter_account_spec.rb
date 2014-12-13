require "rails_helper"

RSpec.describe TwitterAccount, type: :model do
  let(:user) { User.create(uid: "123", screen_name: "screen_name", token: "token", secret: "secret") }
  subject { TwitterAccount.new(
    uid: "123",
    screen_name: "screen_name",
    profile_image_url: "profile_image_url",
    followers_count: "followers_count",
    friends_count: "friends_count",
    statuses_count: "statuses_count"
    )
  }

  it "can belong to a User" do
    subject.user = user
    expect(subject.user).to eq(user)
  end

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

  describe "#profile_image_url" do
    it "is required" do
      subject.profile_image_url = nil
      subject.valid?
      expect(subject.errors.full_messages.first).to eq("Profile image url can't be blank")
    end
  end

  describe "#followers_count" do
    it "is required" do
      subject.followers_count = nil
      subject.valid?
      expect(subject.errors.full_messages.first).to eq("Followers count can't be blank")
    end
  end

  describe "#friends_count" do
    it "is required" do
      subject.friends_count = nil
      subject.valid?
      expect(subject.errors.full_messages.first).to eq("Friends count can't be blank")
    end
  end

  describe "#statuses_count" do
    it "is required" do
      subject.statuses_count = nil
      subject.valid?
      expect(subject.errors.full_messages.first).to eq("Statuses count can't be blank")
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