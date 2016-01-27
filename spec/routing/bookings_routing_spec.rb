require "rails_helper"

RSpec.describe BookingsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/bookings").to route_to("bookings#index")
    end
  end
end
