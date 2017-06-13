# encoding: utf-8

require 'bunny'
require 'json'

class DataManager
  include Singleton

  def initialize
    self.setup
  end

  def publish_resource_data(uuid, capability, value)
    message = JSON(value)
    key = uuid + '.' + capability
    topic = @channel.topic('data_stream')
    topic.publish(message, routing_key: key)
  end

  def publish_actuation_command_status(uuid, capability, command_id, status)
    message = JSON({command_id: command_id, status: status})
    key = uuid + '.' + capability
    topic = @channel.topic('resource.actuate.status')
    topic.publish(message, routing_key: key)
  end

  def setup
    @conn = Bunny.new(hostname: SERVICES_CONFIG['services']['rabbitmq'])
    @conn.start
    @channel = @conn.create_channel
  end
end
