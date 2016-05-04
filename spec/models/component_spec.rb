require "spec_helper"
require "rails_helper"

describe Component, :type => :model do
  subject(:component){ described_class.create!(description: "Small text", lat: -23, lon: -46, capacities: ["temperature", "luminosity", "noise"]) }
  
  context 'with resource' do
    let(:resource) { BasicResource.create! }

    before do
      resource.components << component
    end

    it "belongs to a resource" do
      expect(component.basic_resource).to eq(resource)
    end
  end

  context 'without resource' do
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
    
    describe "#capacities" do
      it "be saved as serialized data" do
        expect(component.capacities.class).to eq(Array)
      end

      it "answer methods with capacities name" do
        component.capacities.each do |cap|
          expect { component.send(cap.to_sym) }.not_to raise_error
        end
      end

      it "returns the original values" do
        expect(component.capacities).to include("temperature")
        expect(component.capacities).to include("luminosity")
        expect(component.capacities).to include("noise")
      end
    end

    describe "#last_collection" do
      it "be saved as serialized data" do
        expect(component.last_collection.class).to eq(Hash)
      end

      it "set last collection data as nil" do
        component.capacities.each do |cap|
          expect(component.last_collection).to have_key(cap.to_s)
        end
      end

      it "answer methods with capacities name" do
        component.capacities.each do |cap|
          expect { component.send(cap.to_sym) }.not_to raise_error
        end
      end

      it "returns the collected data from each capacitie" do
        component.last_collection["temperature"] = 213
        component.last_collection["luminosity"] = 32
        component.last_collection["noise"] = 1.3

        component.capacities.each do |cap|
          expect(component.send(cap)).not_to be_nil
        end
      end

      context "when update capacities" do
        before do
          component.capacities << "humidity"
          component.save!
        end

        it "includes new capacities as methods" do
          expect { component.humidity }.not_to raise_error
        end

        it "responds with default value" do
          expect(component.humidity).to be_nil
        end

        it "continues to respond to other capacities" do
          expect { component.temperature }.not_to raise_error
        end
      end
    end
  end

  context 'when implements real capacities' do
    before do
      component.capacities = []
      component.save
    end

    # TODO: for each capacities, write the needed tests
  end
end
