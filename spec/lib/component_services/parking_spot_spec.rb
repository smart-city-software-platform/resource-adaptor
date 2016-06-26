require "rails_helper"

describe ComponentServices do
  subject(:component) {
    Component.create!(
      description: "Parking spot sensor",
      lat: -23,
      lon: -46
    )
  }

  let(:availability_schedules) {
    [{
      'from'         => 1,
      'to'           => 5,
      'begin_time'   => '00:00',
      'end_time'     => '17:59',
      'is_available' => false
    }]
  }

  describe ComponentServices::ParkingSpot do
    before do
      component.capabilities = ['spot_availability']
      component.service_type = "ParkingSpot"
      component.last_collection['availability_schedules'] =
        availability_schedules.to_json
      component.save!
      component.extend described_class
    end

    it "collects spot availability" do
      expect(component.collect_spot_availability).to(
        be_an_element_of(described_class::SPOT_STATUSES.values))
    end

    it "collects availability schedules" do
      expect(component.collect_availability_schedules).to be_an Array
    end
  end
end
