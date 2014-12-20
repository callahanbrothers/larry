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

  describe "#create_from_twitter_callback" do
    let(:created_user) { User.new }
    let(:created_twitter_account) { TwitterAccount.new }
    let(:created_twitter_service) { TwitterService.new(created_user) }
    let(:twitter_callback) { {
        uid: "123456789",
        token: "token",
        secret: "secret",
        screen_name: "screen_name",
        profile_image_url: "profile_image_url",
        followers_count: 10,
        friends_count: 11,
        statuses_count: 12
      }
    }
    before do
      allow(User).to receive(:create).and_return(created_user)
      allow(TwitterAccount).to receive(:create).and_return(created_twitter_account)
    end

    it "creates a new user" do
      expect(User).to receive(:create).with(
        uid: twitter_callback[:uid],
        secret: twitter_callback[:secret],
        token: twitter_callback[:token]).and_return(created_user)
      User.create_from_twitter_callback(twitter_callback)
    end

    it "creates the new user's twitter account" do
      expect(TwitterAccount).to receive(:create).with(
        user_id: created_user.id,
        uid: twitter_callback[:uid],
        screen_name: twitter_callback[:screen_name],
        profile_image_url: twitter_callback[:profile_image_url],
        followers_count: twitter_callback[:followers_count],
        friends_count: twitter_callback[:friends_count],
        statuses_count: twitter_callback[:statuses_count]
      ).and_return(created_twitter_account)

      User.create_from_twitter_callback(twitter_callback)
    end

    it "fetches the friends of the new user's twitter account" do
      expect(TwitterService).to receive(:new).with(created_user).and_return(created_twitter_service)
      expect_any_instance_of(TwitterService).to receive(:fetch_friends).with(created_twitter_account.id)
      User.create_from_twitter_callback(twitter_callback)
    end
  end
end