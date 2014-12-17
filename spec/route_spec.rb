require "rails_helper"

RSpec.describe "Route", type: :routing do
  describe "home#new" do
    it "routes to the root path" do
      expect(get: "/").to route_to( controller: "home", action: "new" )
    end
  end

  describe "sessions#create" do
    it "handles twitter callbacks" do
      expect(get: "/auth/twitter/callback").to route_to( controller: "sessions", action: "create" )
    end
  end

  describe "sessions#destroy" do
    it "routes to the sign out path" do
      expect(delete: "/sign-out").to route_to( controller: "sessions", action: "destroy" )
    end
  end
end