require "rails_helper"
require "spec_helper"

describe ActuatorsController do
  let(:json) {JSON.parse(response.body)}

  describe '#subscribe' do
    context 'existing resource' do
      before do
        cataloguer_response_body = {
          "data" => {
            "description" => "A simple resource in São Paulo",
            "status" => "stopped",
            "country" => "Brazil",
            "state" => "São Paulo",
            "postal_code" => "05508-090",
            "id" => 677,
            "lon" => -46.731386,
            "updated_at" => "2016-10-28T13:25:16.069Z",
            "uuid" => "956a8ec9-bda7-45b3-85fc-8762cee2879a",
            "city" => "São Paulo",
            "neighborhood" => "Butantã",
            "capabilities" => [
              "semaphore"
            ],
            "created_at" => "2016-10-28T13:25:16.069Z",
            "lat" => -23.559616
          }
        }
        cataloguer_response = double
        allow(cataloguer_response).to receive(:code).and_return(200)
        allow(cataloguer_response).to receive(:body).
          and_return(JSON(cataloguer_response_body))
        allow(Platform::ResourceManager).to receive(:get_resource).
          with("956a8ec9-bda7-45b3-85fc-8762cee2879a").
          and_return(cataloguer_response)
      end

      context "when subscribe to at least one valid capability" do
        let(:request) do
          process :subscribe, method: :post, params: {
            subscription: {
              uuid: "956a8ec9-bda7-45b3-85fc-8762cee2879a",
              url: "http://example.com.br",
              capabilities: ["semaphore"]
            }
          }
        end

        it "returns 201" do
          request
          expect(response).to have_http_status(:created)
        end

        it "creates a subscription on database" do
          expect{ request }.to change(Subscription, :count).by(1)
        end

        describe "json response" do
          subject{ json["subscription"] }
          before { request }

          it { is_expected.not_to be_nil }
          it { is_expected.to have_key("id") }
          it { is_expected.to have_key("uuid") }
          it { is_expected.to have_key("url") }
          it { is_expected.to have_key("capabilities") }
          it { is_expected.to have_key("active") }
        end
      end

      context "when subscribe to invalid capabilities" do
        let(:request) do
          process :subscribe, method: :post, params: {
            subscription: {
              uuid: "956a8ec9-bda7-45b3-85fc-8762cee2879a",
              url: "http://example.com.br",
              capabilities: ["invalid", "not_valid"]
            }
          }
        end

        it "returns 404 error" do
          request
          expect(response).to have_http_status(:not_found)
          expect(json["error"]).to include("This resource does not have these capabilities")
        end

        it "does not create a subscription on database" do
          expect{ request }.to change(Subscription, :count).by(0)
        end
      end

      context 'when missing required parameters on request' do
        it "returns 422 to empty list of capabilities" do
          process :subscribe, method: :post, params: {
            subscription: {
              uuid: "956a8ec9-bda7-45b3-85fc-8762cee2879a",
              url: "http://example.com.br",
              capabilities: []
            }
          }
          expect(response).to have_http_status(422)
          expect(json).to have_key("error")
        end

        it "returns 422 for no capabilities" do
          process :subscribe, method: :post, params: {
            subscription: {
              uuid: "956a8ec9-bda7-45b3-85fc-8762cee2879a",
              url: "http://example.com.br",
            }
          }
          expect(response).to have_http_status(422)
          expect(json).to have_key("error")
        end

        it "returns 422 for no uuid" do
          process :subscribe, method: :post, params: {
            subscription: {
              url: "http://example.com.br",
              capabilities: ["semaphore"],
            }
          }
          expect(response).to have_http_status(422)
          expect(json).to have_key("error")
        end

        it "returns 422 for no url" do
          process :subscribe, method: :post, params: {
            subscription: {
              uuid: "956a8ec9-bda7-45b3-85fc-8762cee2879a",
              capabilities: ["semaphore"],
            }
          }
          expect(response).to have_http_status(422)
          expect(json).to have_key("error")
        end
      end
    end

    context 'when resource is not found' do
      let(:request) do
        process :subscribe, method: :post, params: {
          subscription: {
            uuid: "123456",
            url: "http://example.com.br",
            capabilities: ["semaphore"]
          }
        }
      end

      before do
        cataloguer_response_body = {
          "error" => "Resource with given uuid not found"
        }

        cataloguer_response = double
        allow(cataloguer_response).to receive(:code).and_return(404)
        allow(cataloguer_response).to receive(:body).
          and_return(JSON(cataloguer_response_body))
        allow(Platform::ResourceManager).to receive(:get_resource).
          with("123456").
          and_return(cataloguer_response)
      end

      it "returns 404 error" do
        request
        expect(response).to have_http_status(:not_found)
        expect(json).to have_key("error")
      end
        
      it "does not create a subscription on database" do
        expect{ request }.to change(Subscription, :count).by(0)
      end
    end

    context 'when Resource Catalog is unavailable' do
      let(:request) do
        process :subscribe, method: :post, params: {
          subscription: {
            uuid: "956a8ec9-bda7-45b3-85fc-8762cee2879a",
            url: "http://example.com.br",
            capabilities: ["semaphore"]
          }
        }
      end

      before do
        allow(Platform::ResourceManager).to receive(:get_resource).and_return(nil)
      end

      it "returns 503 error" do
        request
        expect(response).to have_http_status(503)
        expect(json["error"]).to eq('Resource Cataloguer service is unavailable')
      end

      it "does not create a subscription on database" do
        expect{ request }.to change(Subscription, :count).by(0)
      end
    end
  end
end
