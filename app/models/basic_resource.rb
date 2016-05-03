class BasicResource < ActiveRecord::Base
  has_many :components

  after_create :set_url

  def meta_data
    data = {
      id: self.id,
      url: self.url,
      uuid: self.uuid,
      name: self.name,
      model: self.model,
      maker: self.maker,
      created_at: self.created_at,
      updated_at: self.updated_at,
      n_components: self.components.count,
      components: []
    }

    self.components.each do |component|
      component_data = {
        id: component.id, 
        description: component.description, 
        lat: component.lat,
        lon: component.lon,
        capacities: component.capacities
      }

      data[:components] << component_data
    end
    
    data
  end

  def registered?
    !self.uuid.blank?
  end

  # TODO: Criar logs e removes prints
  def create_components(components_data)
    return unless components_data.class == Array
    components_data[self.components.count..components_data.count].each do |component|
      begin
        self.components << Component.new(component)
      rescue
      end
    end
  end

  private

  def set_url
    self.url =  SERVICES_CONFIG["services"]["resource"] + "/" + "#{self.id}"
    self.save
  end
end
