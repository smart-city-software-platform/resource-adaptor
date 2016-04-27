class BasicResource < ActiveRecord::Base
  has_many :components

  def register_data
    return if self.registered?

    self.create_components(RESOURCE_CONFIG["resource"]["components"])
    
    json = {
      url: SERVICES_CONFIG["services"]["resource"] + "/" + "#{self.id}",
      name: RESOURCE_CONFIG["resource"]["name"],
      model: RESOURCE_CONFIG["resource"]["model"],
      maker: RESOURCE_CONFIG["resource"]["maker"],
      n_componentes: RESOURCE_CONFIG["resource"]["components"].count,
      componentes: []
    }

    self.components.each do |component|
      component_data = {
        id: component.id, 
        description: component.description, 
        localization: component.localization, 
        capacities: component.capacities
      }

      json[:componentes] << component_data
    end
    
    puts "HTTP POST #{SERVICES_CONFIG['services']['catalog']}/resource/registry/"

    json
  end

  def registered?
    !self.uuid.blank?
  end

  def create_components(components_data)
    # TODO: Criar logs e removes prints
    puts "Create components:"
    components_data[self.components.count..components_data.count].each do |component|
      begin
        self.components << Component.new(component)
        
        print "."
      rescue
        print "F"
      end
    end
  end
end
