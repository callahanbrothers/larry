class User < ActiveRecord::Base
  has_one :twitter_account

  delegate :screen_name, to: :twitter_account
  delegate :profile_image_url, to: :twitter_account
  delegate :followers_count, to: :twitter_account
  delegate :friends_count, to: :twitter_account
  delegate :statuses_count, to: :twitter_account

  validates :uid, presence: true
  validates :token, presence: true
  validates :secret, presence: true

  def self.create_from_twitter_callback(twitter_callback)
    user = User.create(uid: twitter_callback[:uid], secret: twitter_callback[:secret], token: twitter_callback[:token])
    twitter_account = TwitterAccount.create(
      user_id: user.id,
      uid: twitter_callback[:uid],
      screen_name: twitter_callback[:screen_name],
      profile_image_url: twitter_callback[:profile_image_url],
      followers_count: twitter_callback[:followers_count],
      friends_count: twitter_callback[:friends_count],
      statuses_count: twitter_callback[:statuses_count]
    )
    TwitterService.new(user).fetch_friends(twitter_account.uid)
    user
  end
end
