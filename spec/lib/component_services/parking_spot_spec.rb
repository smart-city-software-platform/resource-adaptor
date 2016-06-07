require "rails_helper"

describe ComponentServices do
  subject(:component) {
    Component.create!(
      description: "Parking spot sensor",
      lat: -23,
      lon: -46
    )
  }

  describe ComponentServices::ParkingSpot do
    before do
      component.capabilities = ["spot_availability"]
      component.service_type = "ParkingSpot"
      component.save!
      component.extend described_class
    end

    it "collects spot availability" do
      expect(component.collect_spot_availability).to(
        be_an_element_of(described_class::SPOT_STATUSES.values))
    end
  end
end
