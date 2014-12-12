class User < ActiveRecord::Base
  validates :uid, presence: true
  validates :screen_name, presence: true
  validates :token, presence: true
  validates :secret, presence: true
end
