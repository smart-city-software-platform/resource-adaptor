require "rails_helper"
require "spec_helper"
require "data_helper"

include DataHelper

describe ComponentsController do
  subject {response}
  let(:json) {JSON.parse(response.body)}
  before do
    create_resources
  end

  describe "#index" do
    context "when request all components data of a resource" do
      let(:resource){BasicResource.last}
      before {get "index", basic_resource_id: resource.id}

      it { is_expected.to be_success }
      it "retrive data from all components" do
        expect(json.count).to eq(resource.components.count)
      end

      it "retrieved components data properly" do
        json.each do |register|
          component = Component.find(register["id"])
          
          expect(resource.components).to include(component)
          expect(component.lat).to eq(register["lat"])
          expect(component.lon).to eq(register["lon"])
          expect(component.status).to eq(register["status"])
          expect(component.capabilities).to eq(register["capabilities"])
          expect(component.description).to eq(register["description"])
        end
      end
    end
    
    context "when request components data of a non existing resource" do
      before {get "index", basic_resource_id: -1}

      it { is_expected.to have_http_status(404) } 
      
      it "retrive no data from any component" do
        expect(json.class).to_not eq(Array)
      end
      
      it "shows the properly not found message" do
        expect(json["code"]).to eq("NotFound")
        expect(json["message"]).to eq("No such resource")
      end
    end
  end

  describe "#status" do
    context "when request all components status of a resource" do
      let(:resource){BasicResource.last}
      before {get "status", basic_resource_id: resource.id}

      it { is_expected.to be_success }
      it "retrive status from all components" do
        expect(json.count).to eq(resource.components.count)
      end

      it "retrieved components status data properly" do
        json.each do |register|
          component = Component.find(register["id"])

          expect(resource.components).to include(component)
          expect(component.status).to eq(register["status"])
          expect(Time.zone.parse(register["updated_at"]).to_date).to eq(component.updated_at.to_date)
        end
      end
    end

    context "when request components status of a non existing resource" do
      before {get "status", basic_resource_id: -1}

      it { is_expected.to have_http_status(404) }

      it "retrive no status data from any component" do
        expect(json.class).to_not eq(Array)
      end

      it "shows the properly not found message" do
        expect(json["code"]).to eq("NotFound")
        expect(json["message"]).to eq("No such resource")
      end
    end
  end
 
  describe "#show" do
    let(:resource){BasicResource.last}
    context "when request a specific component from a resource" do
      let(:component){resource.components.last}

      before {get "show", basic_resource_id: resource.id, id: component.id}

      it { is_expected.to be_success }
      it "retrive only data of specified component" do
        expect(json.class).to_not eq(Array)
        expect(json["data"]["id"]).to eq(component.id)
      end

      it "retrieved component data" do
        expect(json["data"]["id"]).to eq(component.id)
        expect(json["data"]["lat"]).to eq(component.lat)
        expect(json["data"]["lon"]).to eq(component.lon)
        expect(json["data"]["status"]).to eq(component.status)
        expect(json["data"]["capabilities"]).to eq(component.capabilities)
        expect(json["data"]["description"]).to eq(component.description)
        expect(Time.zone.parse(json["data"]["updated_at"]).to_date).to eq(component.updated_at.to_date)
        expect(Time.zone.parse(json["data"]["created_at"]).to_date).to  eq(component.created_at.to_date)
      end
    end

    context "when request a non existing component" do
      before {get "show", basic_resource_id: resource.id, id: -1}

      it { is_expected.to have_http_status(404) } 
      it "shows the not found message" do
        expect(json["code"]).to eq("NotFound")
        expect(json["message"]).to eq("No such component")
      end
    end
  end

  describe "#collect" do
    let(:resource){BasicResource.last}
    context "when request data collected from a component" do
      let(:component){resource.components.last}

      before {get "collect", basic_resource_id: resource.id, id: component.id}

      it { is_expected.to be_success }
      it "retrive only data of specified component" do
        expect(json.class).to_not eq(Array)
      end

      it "retrieved component latest collected data" do
        component.capabilities.each do |cap|
          expect(json["data"][cap]).to eq(component.send(cap))
        end
        expect(Time.zone.parse(json["updated_at"]).to_date).to eq(component.updated_at.to_date)
      end

      context "when something goes wrong" do
        before do
          component.capabilities << "something"
          component.save
          class Component
            def something
              raise Error
            end
          end
          get "collect", basic_resource_id: resource.id, id: component.id
        end

        it { is_expected.to have_http_status(500) }
        it "returns the properly error message" do
          expect(json["code"]).to eq("InternalError")
          expect(json["message"]).to eq("Error while processing the data collection")
        end
      end
    end

    context "when request a non existing component" do
      before {get "collect", basic_resource_id: resource.id, id: -1}

      it { is_expected.to have_http_status(404) }
      it "shows the not found message" do
        expect(json["code"]).to eq("NotFound")
        expect(json["message"]).to eq("No such component")
      end
    end
  end

  describe "#collect_specific" do
    let(:resource){BasicResource.last}
    let(:component){resource.components.last}
    context "when request data collected from a specific capability of an component" do
      let(:capability){component.capabilities.last}
      before {get "collect_specific", basic_resource_id: resource.id, id: component.id, capability: capability}

      it { is_expected.to be_success }
      it "retrive only data from specific capability" do
        expect(json["data"]).to eq(component.send(capability.to_s))
      end
    end

    context "when request a non existing capability" do
      before {get "collect_specific", basic_resource_id: resource.id, id: component.id, capability: "non_existing"}

      it { is_expected.to have_http_status(422) }
      it "shows the unprocessable entry message" do
        expect(json["code"]).to eq("UnprocessableEntry")
        expect(json["message"]).to eq("The required component does not respond to such capability")
      end
    end
  end
end
