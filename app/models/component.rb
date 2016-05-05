require "component_services"

class Component < ActiveRecord::Base
  before_save :set_last_collection
  belongs_to :basic_resource

  serialize :capabilities
  serialize :last_collection, Hash

  def perform
    component = self
    service = "ComponentServices::" + component.service_type
    component.send(:extend, service.constantize)
    Thread.abort_on_exception = true
    Thread.new do
      loop do
        component.capabilities.each do |cap|
          component.last_collection[cap.to_s] = component.send("collect_" + cap.to_s)
        end
        component.save
        sleep component.collect_interval
      end
    end
  end

  def method_missing(method, *arguments, &block)
    if self.last_collection.has_key? method.to_s
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
      status: self.status,
      collect_interval: self.collect_interval,
      last_collection: self.last_collection,
      capabilities: self.capabilities
    }
  end

  def set_last_collection
    return unless self.capabilities.class == Array
    self.capabilities.each do |capability|
      self.last_collection[capability] = nil unless self.last_collection.has_key?(capability)
    end
  end
end
