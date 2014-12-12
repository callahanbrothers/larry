require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  context "POST create" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        "uid" => "123545",
        "info" => {
          "name" => "mockuser"
        },
        "credentials" => {
          "token" => "mock_token",
          "secret" => "mock_secret"
        }
      })
    end

    let(:uid) { request.env["omniauth.auth"]["uid"] }
    let(:screen_name) { request.env["omniauth.auth"]["info"]["nickname"] }
    let(:token) { request.env["omniauth.auth"]["credentials"]["token"] }
    let(:secret) { request.env["omniauth.auth"]["credentials"]["secret"] }
    let(:user) { User.create(uid: "123", screen_name: "screen_name", token: "token", secret: "secret") }

    before(:each) do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      allow(User).to receive(:find_or_create).with(uid, screen_name, token, secret).and_return(user)
      post :create
    end

    it "provides the User as an instance variable" do
      expect(assigns(:user)).to eq(user)
    end

    it "should set user's id in the session" do
      expect(session[:user_id]).to eq(user.id)
    end

    it "should redirect to root" do
      expect(response).to redirect_to root_path
    end

    it "sets a success flash message" do
      expect(flash.notice).to eq("Successfully Logged In")
    end
  end
end