class SessionsController < ApplicationController

  def create
    @found_user = User.find_by(uid: uid.to_s)

    if @found_user.present?
      @user = @found_user
    else
      @user = User.create_from_twitter_callback(formatted_twitter_callback)
    end

    session[:user_id] = @user.id
    flash.notice = "Successfully logged in"
    redirect_to :root
  end

  def destroy
    session[:user_id] = nil
    flash.notice = "You are now logged out"
    redirect_to :root
  end


  private

  def uid
    request.env["omniauth.auth"]["uid"]
  end

  def token
    request.env["omniauth.auth"]["credentials"]["token"]
  end

  def secret
    request.env["omniauth.auth"]["credentials"]["secret"]
  end

  def screen_name
    request.env["omniauth.auth"]["extra"]["raw_info"]["screen_name"]
  end

  def profile_image_url
    request.env["omniauth.auth"]["extra"]["raw_info"]["profile_image_url"].to_s
  end

  def followers_count
    request.env["omniauth.auth"]["extra"]["raw_info"]["followers_count"]
  end

  def friends_count
    request.env["omniauth.auth"]["extra"]["raw_info"]["friends_count"]
  end

  def statuses_count
    request.env["omniauth.auth"]["extra"]["raw_info"]["statuses_count"]
  end

  def formatted_twitter_callback
    { uid: uid,
      token: token,
      secret: secret,
      screen_name: screen_name,
      profile_image_url: profile_image_url,
      followers_count: followers_count,
      friends_count: friends_count,
      statuses_count: statuses_count
    }
  end
end
