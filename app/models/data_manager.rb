# encoding: utf-8

require 'bunny'
require 'json'

class DataManager
  include Singleton

  def initialize
    self.setup
  end

  def publish_resource_data(resource, capability, value)
    message = JSON(value)
    key = resource.uuid + '.' + capability
    @topic.publish(message, routing_key: key)
  end

  def setup
    @conn = Bunny.new(hostname: SERVICES_CONFIG['services']['rabbitmq'])
    @conn.start
    @channel = @conn.create_channel
    @topic = @channel.topic('data_stream')
  end
end
