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
    context "when request all components data" do
      before {get "index"}

      it { is_expected.to be_success }
      it "retrive data from all components" do
        expect(json.count).to eq(Component.count)
      end

      it "retrieved components data properly" do
        json.each do |register|
          component = Component.find(register["id"])
          
          expect(Component.all).to include(component)
          expect(component.lat).to eq(register["lat"])
          expect(component.lon).to eq(register["lon"])
          expect(component.status).to eq(register["status"])
          expect(component.capabilities).to eq(register["capabilities"])
          expect(component.description).to eq(register["description"])
        end
      end
    end
  end

  describe "#status" do
    context "when request all components status" do
      before {get "status"}

      it { is_expected.to be_success }
      it "retrive status from all components" do
        expect(json.count).to eq(Component.count)
      end

      it "retrieved components status data properly" do
        json.each do |register|
          component = Component.find(register["id"])

          expect(Component.all).to include(component)
          expect(component.status).to eq(register["status"])
          expect(Time.zone.parse(register["updated_at"]).to_date).to eq(component.updated_at.to_date)
        end
      end
    end
  end
 
  describe "#show" do
    context "when request a specific component" do
      let(:component){Component.last}

      before {get "show", id: component.id}

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
      before {get "show", id: -1}

      it { is_expected.to have_http_status(404) } 
      it "shows the not found message" do
        expect(json["code"]).to eq("NotFound")
        expect(json["message"]).to eq("No such component")
      end
    end
  end

  describe "#collect" do
    context "when request data collected from a component" do
      let(:component){Component.last}

      before {get "collect", id: component.id}

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
          get "collect", id: component.id
        end

        it { is_expected.to have_http_status(500) }
        it "returns the properly error message" do
          expect(json["code"]).to eq("InternalError")
          expect(json["message"]).to eq("Error while processing the data collection")
        end
      end
    end

    context "when request a non existing component" do
      before {get "collect", id: -1}

      it { is_expected.to have_http_status(404) }
      it "shows the not found message" do
        expect(json["code"]).to eq("NotFound")
        expect(json["message"]).to eq("No such component")
      end
    end
  end

  describe "#collect_specific" do
    let(:component){Component.last}
    context "when request data collected from a specific capability of an component" do
      let(:capability){component.capabilities.last}
      before {get "collect_specific", id: component.id, capability: capability}

      it { is_expected.to be_success }
      it "retrive only data from specific capability" do
        expect(json["data"]).to eq(component.send(capability.to_s))
      end
    end

    context "when request a non existing capability" do
      before {get "collect_specific", id: component.id, capability: "non_existing"}

      it { is_expected.to have_http_status(422) }
      it "shows the unprocessable entry message" do
        expect(json["code"]).to eq("UnprocessableEntry")
        expect(json["message"]).to eq("The required component does not respond to such capability")
      end
    end
  end

  describe "#actuate" do
    let(:component){Component.last}
    context 'when correctly actuate in a capability' do
      let(:capability){'temperature'}
      before do
        put 'actuate', id: component.id, capability: capability, data: {value: 17}
      end

      it { is_expected.to be_success }
      it "retrive actuator status" do
        expect(json['data']['state']).to eq('17')
      end
    end

    context "when request a non existing capability" do
      before {put 'actuate', id: component.id, capability: 'non_existing', data: {value: 17}}

      it { is_expected.to have_http_status(422) }
      it "shows the unprocessable entry message" do
        expect(json["code"]).to eq("UnprocessableEntry")
        expect(json["message"]).to eq("The required component does not respond to such capability")
      end
    end

    context "when request an existing sensor-only capability" do
      before {put 'actuate', id: component.id, capability: 'humidity', data: {value: 17}}

      it { is_expected.to have_http_status(405) }
      it "shows the unprocessable entry message" do
        expect(json["code"]).to eq("MethodNotAllowed")
        expect(json["message"]).to eq("Impossible to actuate over the required capability")
      end
    end

    context "when give wrong params to actuate" do
      before do
        expect(controller).to receive(:actuator_params).and_raise
        put 'actuate', id: component.id, capability: 'temperature', data: {value: nil}
      end

      it { is_expected.to have_http_status(500) }
      it "shows the unprocessable entry message" do
        expect(json["code"]).to eq("InternalError")
        expect(json["message"]).to eq("Error while actuating on device")
      end
    end
  end
end
