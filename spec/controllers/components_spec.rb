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

  describe '#create' do
    context 'correct requests' do
      before do
        Platform::ResourceManager = double
        cataloguer_response_body = {
          "data" => {
            "description" => "A simple resource in São Paulo",
            "status" => "stopped",
            "country" => "Brazil",
            "state" => "São Paulo",
            "uri" => "example2.com",
            "postal_code" => "05508-090",
            "id" => 677,
            "lon" => -46.731386,
            "updated_at" => "2016-10-28T13:25:16.069Z",
            "uuid" => "956a8ec9-bda7-45b3-85fc-8762cee2879a",
            "city" => "São Paulo",
            "neighborhood" => "Butantã",
            "capabilities" => [
              "temperature"
            ],
            "collect_interval" => 5,
            "created_at" => "2016-10-28T13:25:16.069Z",
            "lat" => -23.559616
          }
        }
        cataloguer_response = double
        allow(cataloguer_response).to receive(:code).and_return(201)
        allow(cataloguer_response).to receive(:body).and_return(JSON(cataloguer_response_body))
        allow(Platform::ResourceManager).to receive(:register_resource).and_return(cataloguer_response)

        post 'create',
          data: {
          lat: -23.559616,
          lon: -46.731386,
          status: "stopped",
          description: "A simple resource in São Paulo",
          capabilities: ["temperature"]
        }
      end

      it { is_expected.to have_http_status(:created) }
    end

    context 'Resource Cataloguer unavailable' do
      before do
        Platform::ResourceManager = double
        allow(Platform::ResourceManager).to receive(:register_resource).and_return(nil)

        post 'create',
          data: {
          lat: -23.559616,
          lon: -46.731386,
          status: "stopped",
          description: "A simple resource in São Paulo",
          capabilities: ["temperature"]
        }
      end

      it { is_expected.to have_http_status(503) }
      it 'returns an error message' do
        body = JSON.parse(response.body)
        expect(body["message"]).to eq('Register service is unavailable') end
    end
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

  describe "#data_specific" do
    let(:component){Component.last}
    context 'post one observed data to existing capability' do
      let(:capability){'temperature'}
      before do
        allow_any_instance_of(DataManager).to receive(:setup).and_return(true)
        allow(DataManager.instance).to receive(:publish_resource_data) {true}

        post 'data_specific',
          id: component.id,
          capability: capability,
          data: [{value: '12.8', timestamp: '20/08/2016T10:27:40'}]
      end

      it { is_expected.to have_http_status(201) }
      it 'should update component observation' do
        component.reload
        observations = component.current_data['temperature']
        expect(observations['value']).to eq('12.8')
        expect(observations['timestamp']).to eq('20/08/2016T10:27:40')
      end
    end
  end

  describe "#data" do
    let(:component){Component.last}
    context 'post observed data of two existing capability' do
      before do
        allow_any_instance_of(DataManager).to receive(:setup).and_return(true)
        allow(DataManager.instance).to receive(:publish_resource_data) {true}
        json = {
          data: {
            temperature: [
              {value: '20.2', timestamp: '20/08/2016T10:27:40'}
            ],
            humidity: [
              {value: '67', timestamp: '30/10/2016T06:32:03'}
            ]
          }
        }

        post 'data',
          id: component.id,
          data: {
            temperature: [
              {value: '20.2', timestamp: '20/08/2016T10:27:40'}
            ],
            humidity: [
              {value: '67', timestamp: '30/10/2016T06:32:03'}
            ]
          }
      end

      it { is_expected.to have_http_status(201) }

      it 'should update component temperature observation' do
        component.reload
        observations = component.current_data['temperature']
        expect(observations['value']).to eq('20.2')
        expect(observations['timestamp']).to eq('20/08/2016T10:27:40')
      end

      it 'should update component humidity observation' do
        component.reload
        observations = component.current_data['humidity']
        expect(observations['value']).to eq('67')
        expect(observations['timestamp']).to eq('30/10/2016T06:32:03')
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
  end
end
