require "rails_helper"
require "spec_helper"

describe Platform::ResourceManager do
  before do
    stub_const("SERVICES_CONFIG", YAML.load_file(Rails.root.join("spec", "files", "services.yml")))
    @previous_number_of_component = Component.count
  end
end

