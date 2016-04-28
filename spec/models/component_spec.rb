require "spec_helper"
require "rails_helper"

describe Component, :type => :model do
  subject(:component){ described_class.create!(description: "Small text", localization: "Somewhere") }
  
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

    it "has a localization" do
      expect(component.localization).to eq("Somewhere")
    end
    
    describe "#capacities" do
      before do 
        component.capacities = ["temperature", "luminosity", "noise"]
        component.save!
      end
      
      it "be saved as serialized data" do
        expect(component.capacities.class).to eq(Array)
      end

      it "returns the original values" do
        expect(component.capacities).to include("temperature")
        expect(component.capacities).to include("luminosity")
        expect(component.capacities).to include("noise")
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
