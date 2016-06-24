require "rails_helper"

describe ComponentServices do
  subject(:component) {
    Component.create!(
      description: 'Traffic Flow',
      lat: -23,
      lon: -46
    )
  }

  describe ComponentServices::TrafficFlow do
    before do
      component.capabilities = ['traffic_speed','traffic_density', 'traffic_light_status']
      component.last_collection['traffic_speed'] = 0
      component.last_collection['traffic_density'] = 0
      component.last_collection['traffic_light_status'] = false
      component.service_type = "TrafficFlow"
      component.save!
      component.extend described_class
    end

    context 'when traffic light is green' do
      before do
        component.current_data['traffic_light_status'] = true
      end

      describe '#collect_traffic_light_status' do
        subject{component.collect_traffic_light_status}
        it { is_expected.to be true }
      end

      describe '#collect_traffic_speed' do
        subject{component.collect_traffic_speed}
        it { is_expected.to be >= 0}
        it { is_expected.to be <= 60}
      end

      describe '#collect_traffic_density' do
        subject{component.collect_traffic_density}
        it { is_expected.to be >= 0}
        it { is_expected.to be <= 10}
      end
    end
  
    context 'when traffic light is red' do
      before do
        component.current_data['traffic_light_status'] = false
      end

      describe '#collect_traffic_light_status' do
        subject{component.collect_traffic_light_status}
        it { is_expected.to be false }
      end

      describe '#collect_traffic_speed' do
        subject{component.collect_traffic_speed}
        it { is_expected.to be 0}
      end

      describe '#collect_traffic_density' do
        subject{component.collect_traffic_density}
        it { is_expected.to be >= 0}
        it { is_expected.to be <= 10}
      end
    end
  end
end
