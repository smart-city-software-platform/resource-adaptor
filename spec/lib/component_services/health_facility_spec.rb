require "rails_helper"

describe ComponentServices do
  subject(:component) {
    Component.create!(
      description: 'Health Facility',
      lat: -23,
      lon: -46
    )
  }

  describe ComponentServices::HealthFacility do
    before do
      component.capabilities = ['info_facility_type', 'info_total_capacity', 'current_users']
      component.last_collection['info_facility_type'] = 'Hospital'
      component.last_collection['info_total_capacity'] = 100
      component.service_type = "HealthFacility"
      component.save!
      component.extend described_class
    end

    it "informs facility's type" do
      expect(component.collect_info_facility_type).to eq(component.last_collection['info_facility_type'])
    end

    it "informs total capacity" do
      expect(component.collect_info_total_capacity).to eq(component.last_collection['info_total_capacity'])
    end

    it "collects current users number" do
      expect(component.collect_current_users).to be >= 0
      expect(component.collect_current_users).to be <= (component.last_collection['info_total_capacity'] * 2)
    end
  end
end
