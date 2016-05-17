require "spec_helper"
require "rails_helper"

describe Component, :type => :model do
  subject(:component){ described_class.create!(description: "Small text", lat: -23, lon: -46, capabilities: ["temperature", "luminosity", "noise"]) }
  
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

      it "returns the collected data from each capacitie" do
        component.last_collection["temperature"] = 213
        component.last_collection["luminosity"] = 32
        component.last_collection["noise"] = 1.3

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

    describe "#perform" do
      module ComponentServices
        module Test
          def collect_something
            2.0
          end
        end
      end

      before do
        component.service_type = "Test"
        component.capabilities = ["something"]
        component.save
      end

      it "creates a thread to collect data" do
        thread = component.perform
        expect(thread.status).to_not be false
        thread.exit
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
end
