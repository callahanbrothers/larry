class TwitterAccount < ActiveRecord::Base
  belongs_to :user
  has_many :friend_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy

  has_many :friends, through: :friend_relationships, source: :followed


  has_many :follower_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy

  has_many :followers, through: :follower_relationships, source: :follower

  validates :uid, presence: true
  validates :screen_name, presence: true
  validates :profile_image_url, presence: true
  validates :followers_count, presence: true
  validates :friends_count, presence: true
  validates :statuses_count, presence: true

  def self.create_from_twitter_object(twitter_obj)
    TwitterAccount.create(
      uid: twitter_obj.id,
      screen_name: twitter_obj.screen_name,
      profile_image_url: twitter_obj.profile_image_url.to_s,
      followers_count: twitter_obj.followers_count,
      friends_count: twitter_obj.friends_count,
      statuses_count: twitter_obj.statuses_count
    )
  end
end
