require "rails_helper"

RSpec.describe "Route", type: :routing do
  describe "Root" do
    it "routes to home#new" do
      expect(get: "/").to route_to( controller: "home", action: "new" )
    end
  end

  describe "Twitter Callback" do
    it "routes to sessions#create" do
      expect(get: "/auth/twitter/callback").to route_to( controller: "sessions", action: "create" )
    end
  end
end