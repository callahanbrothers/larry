require "rails_helper"

RSpec.describe User, type: :model do
  subject { User.new(uid: "123", token: "token", secret: "secret") }
  let(:twitter_account) { TwitterAccount.new(
    uid: "123",
    screen_name: "screen_name",
    profile_image_url: "profile_image_url",
    followers_count: "followers_count",
    friends_count: "friends_count",
    statuses_count: "statuses_count"
    )
  }

  before do
    subject.twitter_account = twitter_account
  end

  it "has one twitter account" do
    expect(subject.twitter_account).to eq(twitter_account)
  end

  describe "#uid" do
    it "is required" do
      subject.uid = nil
      subject.valid?
      expect(subject.errors.full_messages.first).to eq("Uid can't be blank")
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

  describe "#screen_name" do
    it "is delegated to the user's twitter_account" do
      expect(subject.screen_name).to eq(subject.twitter_account.screen_name)
    end
  end

  describe "#profile_image_url" do
    it "is delegated to the user's twitter_account" do
      expect(subject.profile_image_url).to eq(subject.twitter_account.profile_image_url)
    end
  end

  describe "#followers_count" do
    it "is delegated to the user's twitter_account" do
      expect(subject.followers_count).to eq(subject.twitter_account.followers_count)
    end
  end

  describe "#friends_count" do
    it "is delegated to the user's twitter_account" do
      expect(subject.friends_count).to eq(subject.twitter_account.friends_count)
    end
  end

  describe "#statuses_count" do
    it "is delegated to the user's twitter_account" do
      expect(subject.statuses_count).to eq(subject.twitter_account.statuses_count)
    end
  end

  describe ".find_or_create" do
    context "when a user already exists" do
      before do
        allow(User).to receive(:find_by).and_return("pre-existing user")
      end

      it "returns the user with the passed in UID" do
        expect(User.find_or_create("123", "token", "secret")).to eq("pre-existing user")
      end
    end

    context "when the user does not exist" do
      before do
        allow(User).to receive(:find_by).and_return(nil)
      end

      it "creates a user with the passed in UID, screen_name, token, and secret" do
        expect{User.find_or_create("123", "token", "secret")}.to change(User, :count).by(1)
      end

      it "returns the newly created user" do
        allow(User).to receive(:create).and_return("new user")

        expect(User.find_or_create("123", "token", "secret")).to eq("new user")
      end
    end

  end
end