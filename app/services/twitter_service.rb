class TwitterService
  TWITTER_USERS_LOOKUP_LIMIT = 100

  def initialize(user)
    user_check(user)

    @twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token = user.token
      config.access_token_secret = user.secret
    end
  end

  def get_friend_ids(uid)
    begin
      @twitter_client.friend_ids(uid.to_i).to_a
    rescue
      false
    end
  end

  def get_profiles(uid_array)
    uid_array_check(uid_array)
    uid_array_size_check(uid_array)

    begin
      @twitter_client.users(uid_array.map(&:to_i))
    rescue
      false
    end
  end

  def get_bulk_profiles(uid_array)
    uid_array_check(uid_array)

    twitter_user_objects = []
    uid_array.each_slice(100) do |slice|
      twitter_user_objects << get_profiles(slice)
    end
    twitter_user_objects.flatten
  end

  def fetch_friends(uid)
    follower = TwitterAccount.find_by(uid: uid.to_s)

    if follower.present?
      friend_ids = get_friend_ids(uid)
      twitter_user_objects = get_bulk_profiles(friend_ids)
      process_twitter_user_objects(twitter_user_objects, follower)
    else
      false
    end
  end


  private

  def process_twitter_user_objects(twitter_user_objects, follower)
    twitter_user_objects.each do |twitter_user_object|
      process_twitter_user_object(twitter_user_object, follower)
    end
  end

  def process_twitter_user_object(twitter_user_object, follower)
    followed = previously_saved_twitter_account(twitter_user_object)

    if followed.nil?
      followed = save_twitter_account(twitter_user_object)
    end

    follow_twitter_account(follower, followed)
  end

  def follow_twitter_account(follower, followed)
    follower.friends << followed
  end

  def save_twitter_account(twitter_user_object)
    TwitterAccount.create_from_twitter_object(twitter_user_object)
  end

  def previously_saved_twitter_account(twitter_user_object)
    TwitterAccount.find_by(uid: twitter_user_object.id.to_s)
  end

  def user_check(user)
    unless user.is_a?(User)
      raise ArgumentError.new("'#{user}' must be a User")
    end
  end

  def uid_array_check(uid_array)
    unless uid_array.is_a?(Array)
      raise ArgumentError.new("'#{uid_array}' must be an Array")
    end
  end

  def uid_array_size_check(uid_array)
    if uid_array.size > TWITTER_USERS_LOOKUP_LIMIT
      raise ArgumentError.new(
        "Twitter can only accept up to #{TWITTER_USERS_LOOKUP_LIMIT} ids at a time, while you passed in #{uid_array.size}"
      )
    end
  end
end