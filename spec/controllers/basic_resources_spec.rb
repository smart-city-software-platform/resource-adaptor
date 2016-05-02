require "rails_helper"
require "spec_helper"

describe BasicResourcesController do
  subject {response}
  let(:json) {JSON.parse(response.body)}
  before do
    create_resources
  end

  context "when request all resources data" do
    before {get "index"}

    it { is_expected.to be_success }
    it "retrive data from all resources" do
      expect(json.count).to eq(BasicResource.count)
    end

    it "retrieved resources" do
      json.each do |resource|
        expect(resource).to have_key("id")
        expect(resource).to have_key("name")
        expect(resource).to have_key("model")
        expect(resource).to have_key("maker")
        expect(resource).to have_key("url")
        expect(resource).to have_key("uuid")
        expect(resource).to have_key("created_at")
        expect(resource).to have_key("updated_at")
      end
    end
  end
  
  context "when request a specific resource" do
    let(:resource){BasicResource.last}

    before {get "show", id: resource.id}

    it { is_expected.to be_success }
    it "retrive only resource data" do
      expect(json.class).to_not eq(Array)
    end

    it "retrieved resource data" do
      expect(json["id"]).to eq(resource.id)
      expect(json["name"]).to eq(resource.name)
      expect(json["model"]).to eq(resource.model)
      expect(json["maker"]).to eq(resource.maker)
      expect(json["url"]).to eq(resource.url)
      expect(json["uuid"]).to eq(resource.uuid)
      expect(Time.zone.parse(json["updated_at"]).to_date).to eq(resource.updated_at.to_date)
      expect(Time.zone.parse(json["created_at"]).to_date).to  eq(resource.created_at.to_date)
    end
  end

  context "when request a non existing resource" do
    before {get "show", id: -1}

    it { is_expected.to have_http_status(404) } 
    it "shows the not found message" do
      expect(json["code"]).to eq("NotFound")
      expect(json["message"]).to eq("No such resource")
    end
  end
end

def create_resources
  resource = BasicResource.create!(
    name: "Arduino",
    model: "Uno",
    maker: "XPTO"
  )

  (1..3).each do |i|
    resource.components << Component.new(
      description: "Text #{i}",
      localization: "Somewhere"
    )
  end
end

