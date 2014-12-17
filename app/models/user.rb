class User < ActiveRecord::Base
  validates :uid, presence: true
  validates :screen_name, presence: true
  validates :token, presence: true
  validates :secret, presence: true

  def self.find_or_create(uid, screen_name, token, secret)
    user = User.find_by(uid: uid)

    if user.present?
      user
    else
      User.create(uid: uid, screen_name: screen_name, token: token, secret: secret)
    end
  end
end
