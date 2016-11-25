require "spec_helper"
require "rails_helper"

describe Component, :type => :model do
  subject(:component){ described_class.create!(description: "Small text", lat: -23, lon: -46, collect_interval: 60, capabilities: ["temperature", "luminosity", "noise"]) }
  
  context 'normal components' do
    it "creates a correct component" do
      expect(component).to eq(Component.last)
    end

    it "has a description" do
      expect(component.description).to eq("Small text")
    end

    it "has a latitude" do
      expect(component.lat).to eq(-23)
    end

    it "has a longitude" do
      expect(component.lon).to eq(-46)
    end

    it "has meta_data" do
      expect(component.meta_data.class).to eq(Hash)
      expect(component.meta_data[:lat]).to eq(-23)
      expect(component.meta_data[:lon]).to eq(-46)
    end
    
    describe "#capabilities" do
      it "be saved as serialized data" do
        expect(component.capabilities.class).to eq(Array)
      end

      it "answer methods with capabilities name" do
        component.capabilities.each do |cap|
          expect { component.send(cap.to_sym) }.not_to raise_error
        end
      end

      it "returns the original values" do
        expect(component.capabilities).to include("temperature")
        expect(component.capabilities).to include("luminosity")
        expect(component.capabilities).to include("noise")
      end
    end

    describe "#last_collection" do
      it "be saved as serialized data" do
        expect(component.last_collection.class).to eq(Hash)
      end

      it "set last collection data as nil" do
        component.capabilities.each do |cap|
          expect(component.last_collection).to have_key(cap.to_s)
        end
      end

      it "answer methods with capabilities name" do
        component.capabilities.each do |cap|
          expect { component.send(cap.to_sym) }.not_to raise_error
        end
      end

      it "returns the collected data from each capability" do
        component.current_data["temperature"] = 213
        component.current_data["luminosity"] = 32
        component.current_data["noise"] = 1.3

        component.capabilities.each do |cap|
          expect(component.send(cap)).not_to be_nil
        end
      end

      context "when update capabilities" do
        before do
          component.capabilities << "humidity"
          component.save!
        end

        it "includes new capabilities as methods" do
          expect { component.humidity }.not_to raise_error
        end

        it "responds with default value" do
          expect(component.humidity).to be_nil
        end

        it "continues to respond to other capabilities" do
          expect { component.temperature }.not_to raise_error
        end
      end

      context "when call a non existing capability" do
        it "raises NoMethodError" do
          expect { component.non_existing_method }.to raise_error(NoMethodError)
        end
      end
    end
  end

  context "scopes" do
    before do
      @component1 = Component.create
      @component2 = Component.create(uuid: "1")
      @component3 = Component.create
    end

    describe ".unregistered" do
      subject(:unregistered_components){ Component.unregistered }

      it { should include(@component1) }
      it { should include(@component3) }
      it { should_not include(@component2) }
    end
  end

  context "collected_data" do
    before do
      Component.collected_data = {}
      @component_a = Component.create(capabilities: ['a', 'b'])
      @component_b = Component.create(capabilities: ['c'])
    end

    describe "#destroy" do
      before do
        @component_a.current_data
        @component_b.current_data
      end
      it 'removes data from destroyed component' do
        expect(Component.collected_data).to have_key(@component_a.id)
        @component_a.destroy
        expect(Component.collected_data).to_not have_key(@component_a.id)
      end

      it 'keep data from non destroyed component' do
        expect(Component.collected_data).to have_key(@component_b.id)
        @component_a.destroy
        expect(Component.collected_data).to have_key(@component_b.id)
      end
    end

    describe "#current_data" do
      it 'maps all capabilities data' do
        expect(@component_a.current_data).to have_key('a')
        expect(@component_a.current_data).to have_key('b')
        expect(@component_b.current_data).to have_key('c')
      end

      it 'returns current data of components' do
        expect(@component_a.current_data['a']).to be nil
        expect(@component_a.current_data['b']).to be nil
        expect(@component_b.current_data['c']).to be nil
      end

      it 'returns correct data previously set of a componet' do
        @component_a.last_collection['a'] = 10
        expect(@component_a.current_data['a']).to eq(10)
      end
    end
  end
end
