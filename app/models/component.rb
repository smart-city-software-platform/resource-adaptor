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
end
