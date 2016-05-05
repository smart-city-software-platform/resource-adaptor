require "rails_helper"
require "spec_helper"
require "component_services"

describe ComponentServices do
  subject(:component){ Component.create!(description: "Small text", lat: -23, lon: -46) }
  describe ComponentServices::OpenWeatherMap do
    before do
      component.capabilities = ["temperature", "luminosity", "noise"]
      component.service_type = "OpenWeatherMap"
      component.save
      component.extend described_class
      expect(component).to receive(:request) { {"main" => {"temp" => 291.2, "humidity" => 94, "pressure" => 1016} } }
    end

    it "properly collect temperature" do
      expect(component.collect_temperature).to eq 291.2
    end

    it "properly collect humidity" do
      expect(component.collect_humidity).to eq 94
    end

    it "properly collect pressure" do
      expect(component.collect_pressure).to eq 1016
    end
  end
end
