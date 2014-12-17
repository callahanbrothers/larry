class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "TwitterAccount"
  belongs_to :followed, class_name: "TwitterAccount"

  validates :follower_id, presence: true
  validates :followed_id, presence: true

end
