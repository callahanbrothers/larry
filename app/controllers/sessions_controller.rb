class SessionsController < ApplicationController
  def create
    @user = User.find_or_create(uid, screen_name, token, secret)
    @user.twitter_account = TwitterAccount.create_from_twitter_object(twitter_object_of_user)

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

  def screen_name
    request.env["omniauth.auth"]["info"]["nickname"]
  end

  def token
    request.env["omniauth.auth"]["credentials"]["token"]
  end

  def secret
    request.env["omniauth.auth"]["credentials"]["secret"]
  end

  def twitter_object_of_user
    request.env["omniauth.auth"]["extra"]["raw_info"]
  end

end
