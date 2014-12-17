require "rails_helper"

RSpec.describe TwitterAccount, type: :model do
  let(:user) { User.create(uid: "123", token: "token", secret: "secret") }
  let(:twitter_params) { {
      uid: "123",
      screen_name: "screen_name",
      profile_image_url: "profile_image_url",
      followers_count: "followers_count",
      friends_count: "friends_count",
      statuses_count: "statuses_count"
    }
  }

  subject { TwitterAccount.new(twitter_params) }

  it "can belong to a User" do
    subject.user = user
    expect(subject.user).to eq(user)
  end

  it "has many friends" do
    subject.save
    expect{
      subject.friends << TwitterAccount.create(twitter_params)
      subject.friends << TwitterAccount.create(twitter_params)
    }.to change(subject.friends, :count).by(2)
  end

  it "has many followers" do
    subject.save
    expect{
      subject.followers << TwitterAccount.create(twitter_params)
      subject.followers << TwitterAccount.create(twitter_params)
    }.to change(subject.followers, :count).by(2)
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

  describe ".create_from_twitter_object" do
    let(:twitter_obj) { Hashie::Mash.new({
        "id" => "123",
        "screen_name" => "screen name",
        "profile_image_url" => "profile image url",
        "followers_count" => 11,
        "friends_count" => 22,
        "statuses_count" => 33
      })
    }

    it "creates a twitter account from the passed in twitter object" do
      expect{TwitterAccount.create_from_twitter_object(twitter_obj)}.to change(TwitterAccount, :count).by(1)
    end

    it "sets the #uid to the integer form of the uid from the passed in twitter object" do
      twitter_account = TwitterAccount.create_from_twitter_object(twitter_obj)
      expect(twitter_account.uid).to eq(twitter_obj.id)
    end

    it "sets the #screen_name to the screen_name from the passed in twitter object" do
      twitter_account = TwitterAccount.create_from_twitter_object(twitter_obj)
      expect(twitter_account.screen_name).to eq(twitter_obj.screen_name)
    end

    it "sets the #profile_image_url to the profile_image_url from the passed in twitter object" do
      twitter_account = TwitterAccount.create_from_twitter_object(twitter_obj)
      expect(twitter_account.profile_image_url).to eq(twitter_obj.profile_image_url)
    end

    it "sets the #followers_count to the followers_count from the passed in twitter object" do
      twitter_account = TwitterAccount.create_from_twitter_object(twitter_obj)
      expect(twitter_account.followers_count).to eq(twitter_obj.followers_count)
    end

    it "sets the #friends_count to the friends_count from the passed in twitter object" do
      twitter_account = TwitterAccount.create_from_twitter_object(twitter_obj)
      expect(twitter_account.friends_count).to eq(twitter_obj.friends_count)
    end

    it "sets the #statuses_count to the statuses_count from the passed in twitter object" do
      twitter_account = TwitterAccount.create_from_twitter_object(twitter_obj)
      expect(twitter_account.statuses_count).to eq(twitter_obj.statuses_count)
    end
  end
end