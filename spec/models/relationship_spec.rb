require "rails_helper"

RSpec.describe Relationship, type: :model do
  let(:follower_twitter_account) { TwitterAccount.create(
    uid: "123",
    screen_name: "follower screen_name",
    profile_image_url: "follower profile_image_url",
    followers_count: "follower followers_count",
    friends_count: "follower friends_count",
    statuses_count: "follower statuses_count"
    )
  }

  let(:followed_twitter_account) { TwitterAccount.create(
    uid: "456",
    screen_name: "followed screen_name",
    profile_image_url: "followed profile_image_url",
    followers_count: "followed followers_count",
    friends_count: "followed friends_count",
    statuses_count: "followed statuses_count"
    )
  }

  subject { Relationship.new(
    follower_id: follower_twitter_account.id,
    followed_id: followed_twitter_account.id)
  }

  it "belongs to a follower twitter account" do
    expect(subject.follower).to eq(follower_twitter_account)
  end

  it "belongs to a followed twitter account" do
    expect(subject.followed).to eq(followed_twitter_account)
  end

  describe "#follower_id" do
    it "is required" do
      subject.follower_id = nil
      subject.valid?
      expect(subject.errors.full_messages.first).to eq("Follower can't be blank")
    end
  end

  describe "#followed_id" do
    it "is required" do
      subject.followed_id = nil
      subject.valid?
      expect(subject.errors.full_messages.first).to eq("Followed can't be blank")
    end
  end

end