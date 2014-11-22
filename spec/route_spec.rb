require "rails_helper"

RSpec.describe "Route", type: :routing do
  describe "Root" do
    it "routes the home#index page" do
      expect(get: "/").to route_to( controller: "home", action: "index" )
    end
  end
end