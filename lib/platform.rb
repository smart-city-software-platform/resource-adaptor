require 'json'

module Platform
  module ResourceManager
    def self.register_resources
      return if BasicResource.count == RESOURCE_CONFIG["resources"].count

      #TODO: Logger
      RESOURCE_CONFIG["resources"][BasicResource.count..-1].each do |resource_data|
        resource = BasicResource.new
        resource.name = resource_data["name"]
        resource.model = resource_data["model"]
        resource.maker = resource_data["maker"]
        resource.save!
        resource.create_components(resource_data["components"])
        Platform::ResourceManager.register(resource.meta_data)
      end
    end
    
    def self.register(json)
      "HTTP POST #{SERVICES_CONFIG['services']['catalog']}/resource/registry/" + json.to_json
    end
  end
end
