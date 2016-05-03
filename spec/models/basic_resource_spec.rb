require "rails_helper"
require "spec_helper"

describe BasicResource do
  subject(:resource) {described_class.new}
  
  before do
    resource.name = "A name"
    resource.model = "A model"
    resource.maker = "A maker"
    resource.save!
  end
  
  describe "#save" do
    it "registers name" do
      expect(resource.name).to eq("A name")
    end
    
    it "registers model" do
      expect(resource.model).to eq("A model")
    end

    it "registers maker" do
      expect(resource.maker).to eq("A maker")
    end

    it "automaticly generates its url" do
      stub_const("SERVICES_CONFIG", YAML.load_file(Rails.root.join("spec", "files", "services.yml")))
      
      expect(resource.url).to eq(SERVICES_CONFIG["services"]["resource"] + "/" + resource.id.to_s)
    end
  end

  describe "#create_components" do
    before do
      resource.save!
      stub_const("RESOURCE_CONFIG", YAML.load_file(Rails.root.join("spec", "files", "resource.yml")))
    end
    
    context "when receives correct data" do
      it "creates 3 components" do
        resource.create_components(RESOURCE_CONFIG["resources"].first["components"])
        expect(resource.components.count).to eq(3)
      end
    end

    context "when receives empty data" do
      it "does not create any component" do
        resource.create_components([])
        expect(resource.components.count).to eq(0)
      end
    end
    
    context "when receives bad data" do
      it "does not create any component" do
        resource.create_components({})
        expect(resource.components.count).to eq(0)
      end
    end
  end

  describe "#registered?" do
    context "when does not have uuid" do
      it "is not registered" do
        expect(resource.registered?).to be false
      end
    end
    
    context "when has uuid" do
      it "is registered" do
        resource.uuid = "12345" 
        resource.save!

        expect(resource.registered?).to be true
      end
    end
  end

  describe "meta_data" do
    subject {resource.meta_data}

    before do 
      stub_const("RESOURCE_CONFIG", YAML.load_file(Rails.root.join("spec", "files", "resource.yml")))
    end

    it { is_expected.to have_key(:id) }
    it { is_expected.to have_key(:uuid) }
    it { is_expected.to have_key(:url) }
    it { is_expected.to have_key(:name) }
    it { is_expected.to have_key(:model) }
    it { is_expected.to have_key(:maker) }
    it { is_expected.to have_key(:created_at) }
    it { is_expected.to have_key(:updated_at) }
    it { is_expected.to have_key(:n_components) }
    it { is_expected.to have_key(:components) }
  end
end

