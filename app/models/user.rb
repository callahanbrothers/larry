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

  def self.find_or_create(uid, token, secret)
    user = User.find_by(uid: uid)

    if user.present?
      user
    else
      User.create(uid: uid, token: token, secret: secret)
    end
  end
end
