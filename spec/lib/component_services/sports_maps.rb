require "rails_helper"

describe ComponentServices do
  subject(:component) {
    Component.create!(
      description: 'SportsMaps',
      lat: -23,
      lon: -46
    )
  }

  describe ComponentServices::SportsMaps do
    before do
      component.capabilities = ['temperature', 'humidity', 'uv', 'pollution', 'info_green_percentage']
      component.last_collection['info_green_percentage'] = 60
      component.service_type = "SportsMaps"
      expect(component).to receive(:request) { {"main" => {"temp" => 291.2, "humidity" => 94, "pressure" => 1016} } }
      component.save!
      component.extend described_class
    end

    it "informs green percetenge" do
      expect(component.collect_info_green_percentage).to eq(component.last_collection['info_green_percentage'])
    end

    it "collects temperature" do
      expect(component.collect_temperature).to eq(291.2)
    end

    it "collects humidity" do
      expect(component.collect_humidity).to eq(94)
    end

    it "collects uv" do
      expect(component.collect_uv).to be >= 0
      expect(component.collect_uv).to be <= 15
    end

    it "collects pollution" do
      expect(component.collect_pollution).to be >= 0
      expect(component.collect_pollution).to be <= 500
    end
  end
end
