require "rails_helper"

RSpec.describe TwitterService, type: :model do
  let(:user) { User.create(uid: "123", token: "token", secret: "secret") }
  let(:twitter_account) { TwitterAccount.create(
      uid: "123",
      screen_name: "screen_name",
      profile_image_url: "profile_image_url",
      followers_count: "followers_count",
      friends_count: "friends_count",
      statuses_count: "statuses_count"
    )
  }

  before do
    user.twitter_account = twitter_account
  end

  subject { TwitterService.new(user) }

  describe "initialize" do
    it "requires a user object as the argument" do
      expect{ TwitterService.new("not a user object") }.to raise_error(ArgumentError, "'not a user object' must be a User")
    end

    it "returns a Twitter::REST::Client object" do
      expect(subject.instance_variable_get(:@twitter_client)).to be_instance_of(Twitter::REST::Client)
    end

    it "sets the consumer_key on the twitter_client to the application's consumer key" do
      expect(subject.instance_variable_get(:@twitter_client).consumer_key).to eq(ENV["TWITTER_CONSUMER_KEY"])
    end

    it "sets the consumer_secret on the twitter_client to the application's consumer key" do
      expect(subject.instance_variable_get(:@twitter_client).consumer_secret).to eq(ENV["TWITTER_CONSUMER_SECRET"])
    end

    it "sets the access_token on the twitter_client to the passed in user's access token" do
      expect(subject.instance_variable_get(:@twitter_client).access_token).to eq(user.token)
    end

    it "sets the access_token_secret on the twitter_client to the passed in user's access token" do
      expect(subject.instance_variable_get(:@twitter_client).access_token_secret).to eq(user.secret)
    end
  end

  describe "#get_friend_ids" do
    context "when there are no errors from twitter" do
      it "returns an array of twitter uids from twitter" do
        twitter_cursor_double = instance_double(Twitter::Cursor, to_a: [1,2])

        allow(
          subject.instance_variable_get(:@twitter_client)
        ).to receive(:friend_ids).with(123).and_return(twitter_cursor_double)

        expect(subject.get_friend_ids("123")).to eq([1,2])
      end
    end

    context "when there are errors from twitter" do
      it "does something TBD" do
        allow(
          subject.instance_variable_get(:@twitter_client)
        ).to receive(:friend_ids).with(123).and_raise(Twitter::Error)

        expect(subject.get_friend_ids(123)).to eq(false)
      end
    end
  end

  describe "#get_profiles" do
    it "requires an Array as the argument" do
      expect{ expect(subject.get_profiles("not an array")) }.to raise_error(ArgumentError,
        "'not an array' must be an Array")
    end

    it "does not accept an array of more than 100 as the argument" do
      expect{ expect(subject.get_profiles(Array.new(101))) }.to raise_error(ArgumentError,
        "Twitter can only accept up to 100 ids at a time, while you passed in 101")
    end

    context "when there are no errors from twitter" do
      it "returns an array of twitter profile objects from twitter" do
        twitter_user_double_array = [instance_double(Twitter::User),instance_double(Twitter::User)]

        allow(
          subject.instance_variable_get(:@twitter_client)
        ).to receive(:users).with([123, 456]).and_return(twitter_user_double_array)

        expect(subject.get_profiles(["123", "456"])).to eq(twitter_user_double_array)
      end
    end

    context "when there are errors from twitter" do
      it "returns false" do
        allow(
          subject.instance_variable_get(:@twitter_client)
        ).to receive(:get_profiles).with([123, 456]).and_raise(Twitter::Error)

        expect(subject.get_profiles([123, 456])).to eq(false)
      end
    end
  end

  describe "#get_bulk_profiles" do
    it "requires an Array as the argument" do
      expect{ expect(subject.get_bulk_profiles("not an array")) }.to raise_error(ArgumentError,
        "'not an array' must be an Array")
    end

    context "when there are no errors from twitter" do
      context "when there are 100 or less uids passed in" do
        it "returns an array of twitter profile objects from twitter" do
          twitter_user_double_array = [instance_double(Twitter::User),instance_double(Twitter::User)]

          allow(
            subject.instance_variable_get(:@twitter_client)
          ).to receive(:users).with([123, 456]).and_return(twitter_user_double_array)

          expect(subject.get_bulk_profiles([123, 456])).to eq(twitter_user_double_array)
        end
      end

      context "when there more than 100 uids passed in" do
        it "returns an array of twitter profile objects from twitter" do
          twitter_user_double_array = [instance_double(Twitter::User),instance_double(Twitter::User)]

          allow(
            subject.instance_variable_get(:@twitter_client)
          ).to receive(:users).and_return(twitter_user_double_array)

          expect(subject.get_bulk_profiles(Array.new(101))).to eq([twitter_user_double_array, twitter_user_double_array].flatten)
        end
      end
    end

    context "when there are errors from twitter" do
      it "does something TBD" do
        allow(
          subject.instance_variable_get(:@twitter_client)
        ).to receive(:get_profiles).with([123, 456]).and_raise(Twitter::Error)

        expect(subject.get_profiles(["123", "456"])).to eq(false)
      end
    end
  end

  describe "#fetch_friends" do
    let(:previously_saved_twitter_double) {
      instance_double(Twitter::User,
        id: twitter_account.uid,
        screen_name: "screen_name",
        profile_image_url: "profile_image_url",
        followers_count: "followers_count",
        friends_count: "friends_count",
        statuses_count: "statuses_count"
      )
    }

    let(:unsaved_twitter_double) {
      instance_double(Twitter::User,
        id: "unsaved uid",
        screen_name: "screen_name",
        profile_image_url: "profile_image_url",
        followers_count: "followers_count",
        friends_count: "friends_count",
        statuses_count: "statuses_count"
      )
    }

    it "trys to find the follower based on the uid passed in as an argument" do
      expect(TwitterAccount).to receive(:find_by).with(uid: user.uid)
      subject.fetch_friends(user.uid)
    end

    context "when the follower is present" do
      before do
        allow(subject).to receive(:get_friend_ids).with(user.uid).and_return([1,2])
        allow(subject).to receive(:get_bulk_profiles).with([1, 2]).and_return([previously_saved_twitter_double, unsaved_twitter_double])
      end

      it "gets the friend ids of the follower" do
        expect(subject).to receive(:get_friend_ids).with(user.uid).and_return([1,2])
        subject.fetch_friends(user.uid)
      end

      it "gets the profiles of the friend ids" do
        expect(subject).to receive(:get_bulk_profiles).with([1,2]).and_return([previously_saved_twitter_double, unsaved_twitter_double])
        subject.fetch_friends(user.uid)
      end

      context "when the followed is already in the database" do
        it "does not save the follwed twitter account again" do
          allow(subject).to receive(:get_bulk_profiles).with([1, 2]).and_return([previously_saved_twitter_double])
          expect{subject.fetch_friends(user.uid)}.to change(TwitterAccount, :count).by(0)
        end
      end

      context "when the followed is not in the database yet" do
        it "saves the new twitter account to the database" do
          allow(subject).to receive(:get_bulk_profiles).with([1, 2]).and_return([unsaved_twitter_double])
          expect{subject.fetch_friends(user.uid)}.to change(TwitterAccount, :count).by(1)
        end
      end

      it "sets up a many to many association between the friend and each saved twitter account" do
        expect{subject.fetch_friends(user.uid)}.to change(twitter_account.friends, :count).by(2)
      end
    end

    context "when the follower is not present" do
      it "returns false" do
        allow(TwitterAccount).to receive(:find_by).with(uid: "uid of twitter account not already saved").and_return(nil)
        expect(subject.fetch_friends("uid of twitter account not already saved")).to eq(false)
      end
    end
  end
end