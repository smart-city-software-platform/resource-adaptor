require 'yaml'

if Rails.env.development? || Rails.env.production?
  SERVICES_CONFIG = YAML.load_file(Rails.root.join("config", "services.yml"))
  RESOURCE_CONFIG = YAML.load_file(Rails.root.join("config", "resource.yml"))
end
