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
          expect(component.localization).to eq(register["localization"])
          expect(component.capacities).to eq(register["capacities"])
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
 
  describe "#show" do
    let(:resource){BasicResource.last}
    context "when request a specific component from a resource" do
      let(:component){resource.components.last}

      before {get "show", basic_resource_id: resource.id, id: component.id}

      it { is_expected.to be_success }
      it "retrive only data of specified component" do
        expect(json.class).to_not eq(Array)
        expect(json["id"]).to eq(component.id)
      end

      it "retrieved component data" do
        expect(json["id"]).to eq(component.id)
        expect(json["localization"]).to eq(component.localization)
        expect(json["capacities"]).to eq(component.capacities)
        expect(json["description"]).to eq(component.description)
        expect(Time.zone.parse(json["updated_at"]).to_date).to eq(component.updated_at.to_date)
        expect(Time.zone.parse(json["created_at"]).to_date).to  eq(component.created_at.to_date)
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
end
