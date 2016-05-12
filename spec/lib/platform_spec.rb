require "rails_helper"
require "spec_helper"

describe Platform::ResourceManager do
  before do
    stub_const("SERVICES_CONFIG", YAML.load_file(Rails.root.join("spec", "files", "services.yml")))
    stub_const("RESOURCE_CONFIG", YAML.load_file(Rails.root.join("spec", "files", "resource.yml")))

    @previous_number_of_resources = BasicResource.count
    @previous_number_of_component = Component.count
    described_class.create_all
  end

  context "when there aren't new resources data" do
    before do 
      @previous_number_of_resources = BasicResource.count
      @previous_number_of_component = Component.count
      described_class.create_all
    end

    it "does't create new resources" do
      expect(BasicResource.count).to eq(@previous_number_of_resources)
    end
    
    it "does't create new components" do
      expect(Component.count).to eq(@previous_number_of_component)
    end
  end

  context "when there are new resources data" do
    it "creates new resources" do
      expect(BasicResource.count).to be > @previous_number_of_resources
    end
    
    it "creates new components" do
      expect(Component.count).to be > @previous_number_of_component
    end
 
    context "when saves resources" do
      let(:created_resource) {BasicResource.last}
      let(:created_component) {Component.last}

      it "properly store resource's data" do
        expect(created_resource.name).to be_truthy
        expect(created_resource.model).to be_truthy
        expect(created_resource.maker).to be_truthy
        expect(created_resource.url).to be_truthy
      end
      
      it "properly store components's data" do
        expect(created_resource.components.count).to be > 0
      end
    end
  end
end

