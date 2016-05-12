require 'json'

module Platform
  module ResourceManager
    def self.create_all
      return if BasicResource.count == RESOURCE_CONFIG["resources"].count

      #TODO: Logger
      RESOURCE_CONFIG["resources"][BasicResource.count..-1].each do |resource_data|
        resource = BasicResource.new
        resource.name = resource_data["name"]
        resource.model = resource_data["model"]
        resource.maker = resource_data["maker"]
        resource.save!
        resource.create_components(resource_data["components"])
      end
    end
    
    def self.register_all
      Component.find_each do |component|
        data = component.meta_data
      "HTTP POST #{SERVICES_CONFIG['services']['catalog']}/resource/registry/" + data.to_json
      end
    end
  end
end
