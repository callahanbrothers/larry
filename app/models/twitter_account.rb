class TwitterAccount < ActiveRecord::Base
  belongs_to :user

  validates :uid, presence: true
  validates :screen_name, presence: true
  validates :profile_image_url, presence: true
  validates :followers_count, presence: true
  validates :friends_count, presence: true
  validates :statuses_count, presence: true

end
