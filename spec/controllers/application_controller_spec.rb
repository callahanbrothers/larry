require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  describe "#current_user" do
    controller do
      def index
        @user = current_user
        render text: "response"
      end
    end

    context "when there is not a user logged in" do
      it "returns nil" do
        get :index
        expect(assigns(:user)).to eq(nil)
      end
    end

    context "when there is a user logged in" do
      it "returns the user" do
        user = User.create(uid: "123", token: "token", secret: "secret")
        session[:user_id] = user.id
        get :index
        expect(assigns(:user)).to eq(user)
      end
    end
  end

  describe "#user_signed_in?" do
    controller do
      def index
        @signed_in_user = user_signed_in?
        render text: "response"
      end
    end

    context "when there is not a user logged in" do
      it "returns false" do
        get :index
        expect(assigns(:signed_in_user)).to eq(false)
      end
    end

    context "when there is a user logged in" do
      it "returns false" do
        user = User.create(uid: "123", token: "token", secret: "secret")
        session[:user_id] = user.id
        get :index
        expect(assigns(:signed_in_user)).to eq(true)
      end
    end
  end
end