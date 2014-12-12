require "rails_helper"

RSpec.describe "Twitter Callback" do
  context "with a valid callback url" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        "provider" => "twitter",
        "uid" => "123545",
        "user_info" => {
          "name" => "mockuser",
          "image" => "mock_user_thumbnail_url"
        },
        "credentials" => {
          "token" => "mock_token",
          "secret" => "mock_secret"
        }
      })
    end

    before(:each) do
      get "auth/twitter/callback"
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    end

    # it "should set user_id" do
    #   expect(session[:user_id]).to eq(User.last.id)
    # end

    it "should redirect to root" do
      expect(response).to redirect_to root_path
    end

    it "sets a success flash message" do
      expect(flash.notice).to eq("Successfully Logged In")
    end
  end
end