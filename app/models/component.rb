require "component_services"

class Component < ActiveRecord::Base
  cattr_accessor :collected_data
  @@collected_data = {}

  before_save :set_last_collection
  after_destroy { |record| Component.collected_data.except!(record.id) }

  serialize :capabilities
  serialize :last_collection, Hash

  scope :unregistered, -> { where(uuid: nil) }
  scope :registered, -> { where.not(uuid: nil) }

  def perform
    component = self
    service = "ComponentServices::" + component.service_type
    component.send(:extend, service.constantize)
    Thread.abort_on_exception = true
    Thread.new do
      loop do
        component.capabilities.each do |cap|
          component.current_data[cap.to_s] = component.send("collect_" + cap.to_s)
        end
        sleep component.collect_interval
      end
    end
  end

  def current_data
    Component.collected_data[self.id] = self.last_collection if Component.collected_data[self.id].nil?
    Component.collected_data[self.id]
  end

  def observations
    current_data
  end

  def method_missing(method, *arguments, &block)
    if self.current_data.has_key? method.to_s
      self.current_data[method.to_s]
    elsif self.last_collection.has_key? method.to_s
      self.last_collection[method.to_s]
    else
      super
    end
  end

  def meta_data
    {
      id: self.id,
      description: self.description,
      lat: self.lat,
      lon: self.lon,
      uri: self.uri,
      status: self.status,
      collect_interval: self.collect_interval,
      last_collection: self.current_data,
      capabilities: self.capabilities
    }
  end

  def set_last_collection
    return unless self.capabilities.class == Array
    self.capabilities.each do |capability|
      self.last_collection[capability] = nil unless self.last_collection.has_key?(capability)
    end
  end

  def uri
   SERVICES_CONFIG['services']['resource'] + "/components/#{self.id}"
  end
end
