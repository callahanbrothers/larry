require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "POST create" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        "uid" => "123456789",
        "info" => {
          "nickname" => "screen name"
        },
        "credentials" => {
          "token" => "token",
          "secret" => "secret"
        },
        "extra" => {
          "raw_info" => {
            "id" => "123456789",
            "screen_name" => "screen name",
            "profile_image_url" => "profile image url",
            "followers_count" => 11,
            "friends_count" => 22,
            "statuses_count" => 33
          }
        }
      })
    end

    let(:uid) { request.env["omniauth.auth"]["uid"] }
    let(:token) { request.env["omniauth.auth"]["credentials"]["token"] }
    let(:secret) { request.env["omniauth.auth"]["credentials"]["secret"] }
    let(:screen_name) { request.env["omniauth.auth"]["extra"]["raw_info"]["screen_name"] }
    let(:profile_image_url) { request.env["omniauth.auth"]["extra"]["raw_info"]["profile_image_url"].to_s }
    let(:followers_count) { request.env["omniauth.auth"]["extra"]["raw_info"]["followers_count"] }
    let(:friends_count) { request.env["omniauth.auth"]["extra"]["raw_info"]["friends_count"] }
    let(:statuses_count) { request.env["omniauth.auth"]["extra"]["raw_info"]["statuses_count"] }

    let(:twitter_service_instance_double) { instance_double(TwitterService, fetch_friends: "foo") }
    let(:user_instance_double) { instance_double(User, id: "id", create_twitter_account: "twitter account") }

    before(:each) do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    end

    let(:formatted_twitter_callback) { {
        uid: uid,
        token: token,
        secret: secret,
        screen_name: screen_name,
        profile_image_url: profile_image_url,
        followers_count: followers_count,
        friends_count: friends_count,
        statuses_count: statuses_count
      }
    }
    let!(:returned_user) { User.new }

    before do
      allow(User).to receive(:create_from_twitter_callback).with(formatted_twitter_callback).and_return(returned_user)
    end

    context "when the user does not exist" do
      it "assigns @found_user to nil" do
        post :create
        expect(assigns(:found_user)).to eq(nil)
      end

      it "creates a new user from twitter with the correct params" do
        expect(User).to receive(:create_from_twitter_callback).with(formatted_twitter_callback).and_return(User.new)
        post :create
      end

      it "assigns @user to the newly created user" do
        post :create
        expect(assigns(:user)).to eq(returned_user)
      end
    end

    context "when a user already exists" do
      let!(:previous_user) { User.create(uid: "123456789", token: "token", secret: "secret")}

      it "assigns @found_user to the found user" do
        post :create
        expect(assigns(:found_user)).to eq(previous_user)
      end

      it "assigns @user to @found_user" do
        post :create
        expect(assigns(:user)).to eq(previous_user)
      end
    end

    it "should set user's id in the session" do
      expect(session[:user_id]).to eq(returned_user.id)
      post :create
    end

    it "redirects to the root" do
      post :create
      expect(response).to redirect_to root_path
    end

    it "sets a success message in the notice" do
      post :create
      expect(flash.notice).to eq("Successfully logged in")
    end
  end

  describe "DELETE destroy" do
    context "when the user is signed in" do
      before do
        session[:user_id] = 1
      end

      it "clears out the session" do
        delete :destroy
        expect(session[:user_id]).to be_nil
      end

      it "redirects to the root" do
        delete :destroy
        expect(response).to redirect_to root_path
      end

      it "sets a success message in the notice" do
        delete :destroy
        expect(flash.notice).to eq("You are now logged out")
      end
    end
  end
end