require "rails_helper"

describe ComponentServices do
  subject(:component) {
    Component.create!(
      description: "Parking spot sensor",
      lat: -23,
      lon: -46
    )
  }

  let(:availability_schedules_restricted) {
    [{
      'from'         => 0,
      'to'           => 6,
      'begin_time'   => '00:00',
      'end_time'     => '23:59',
      'is_available' => false
    }]
  }

  let(:availability_schedules_unrestricted) {
    []
  }

  describe ComponentServices::ParkingSpot do
    before do
      component.capabilities = ['spot_availability']
      component.service_type = "ParkingSpot"
      component.save!
      component.extend described_class
    end

    context 'with parking restrictions' do
      it "collects spot availability" do
        component.last_collection['availability_schedules'] =
          availability_schedules_restricted

        expect(component.collect_spot_availability).to(
          eq(described_class::SPOT_STATUSES[:available]))
      end
    end

    context 'without parking restrictions' do
      it "collects spot availability" do
        component.last_collection['availability_schedules'] =
          availability_schedules_unrestricted

        expect(component.collect_spot_availability).to(
          be_an_element_of(described_class::SPOT_STATUSES.values))
      end
    end

    context 'when it is first loaded from the DB' do
      it "collects availability schedules" do
        component.last_collection['availability_schedules'] =
          availability_schedules_restricted.to_json

        component.save!
        expect(component.collect_availability_schedules).to be_an Array
      end
    end

    context 'when it is already in memory' do
      it "collects availability schedules" do
        component.last_collection['availability_schedules'] =
          availability_schedules_restricted

        expect(component.collect_availability_schedules).to be_an Array
      end
    end
  end
end
