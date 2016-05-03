require 'open_weather_map_helper'

class Component < ActiveRecord::Base
  include ExternalAPI::OpenWeatherMap

  belongs_to :basic_resource

  serialize :capacities

  def temperature
    begin
      self.get_temperature
    rescue
      nil
    end
  end

  def pressure
  end

  def humidity
  end

  def manipulate_led(on = true)
    # code to send signal to led
    # return OK if ok
    # return ERROR if !ok
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
      capacities: self.capacities
    }
  end
end
