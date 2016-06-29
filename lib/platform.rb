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
      registered = 0
      Component.unregistered.each do |component|
        begin
          data = component.meta_data
          response = RestClient.post SERVICES_CONFIG['services']['catalog'] + "/resources", {data: data}
          if response.code == 201
            json = JSON.parse(response)
            component.uuid = json["data"]["uuid"]
            raise Exception, 'No uuid returned' if component.uuid.nil?
            component.save!
            registered = registered + 1
          end
        rescue Exception => e
          puts "Could not register Component #{component.id} - ERROR #{e}"
        end
      end

      registered
    end

    def self.update(capability_name = "")
      updated = 0
      Component.registered.each do |component|
        begin
          data = component.meta_data
          response = RestClient.put SERVICES_CONFIG['services']['catalog'] + "/resources/#{component.uuid}", {data: data}
          if response.code == 204
            updated = updated + 1
          end
        rescue Exception => e
          puts "Could not update Component #{component.id} - ERROR #{e}"
        end
      end

      updated
    end
  end
end
