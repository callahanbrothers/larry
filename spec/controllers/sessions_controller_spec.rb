require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  let(:user) { User.create(uid: "123", screen_name: "screen_name", token: "token", secret: "secret") }

  describe "POST create" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        "uid" => "uid",
        "info" => {
          "nickname" => "screen name"
        },
        "credentials" => {
          "token" => "token",
          "secret" => "secret"
        },
        "extra" => {
          "raw_info" => {
            "id" => "uid",
            "screen_name" => "screen name",
            "profile_image_url" => "profile image url",
            "followers_count" => "11",
            "friends_count" => "22",
            "statuses_count" => "33"
          }
        }
      })
    end

    let(:uid) { request.env["omniauth.auth"]["uid"] }
    let(:screen_name) { request.env["omniauth.auth"]["info"]["nickname"] }
    let(:token) { request.env["omniauth.auth"]["credentials"]["token"] }
    let(:secret) { request.env["omniauth.auth"]["credentials"]["secret"] }

    before(:each) do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      allow(User).to receive(:find_or_create).with(uid, screen_name, token, secret).and_return(user)
      post :create
    end

    it "provides the User as an instance variable" do
      expect(assigns(:user)).to eq(user)
    end

    it "creates the user's twitter account" do
      expect(user.twitter_account.uid).to eq("uid")
      expect(user.twitter_account.screen_name).to eq("screen name")
      expect(user.twitter_account.profile_image_url).to eq("profile image url")
      expect(user.twitter_account.followers_count).to eq(11)
      expect(user.twitter_account.friends_count).to eq(22)
      expect(user.twitter_account.statuses_count).to eq(33)
    end

    it "should set user's id in the session" do
      expect(session[:user_id]).to eq(user.id)
    end

    it "redirects to the root" do
      expect(response).to redirect_to root_path
    end

    it "sets a success message in the notice" do
      expect(flash.notice).to eq("Successfully logged in")
    end
  end

  describe "DELETE destroy" do
    context "when the user is signed in" do
      before do
        session[:user_id] = user.id
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