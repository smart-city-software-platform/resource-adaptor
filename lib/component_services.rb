require 'json'
require 'rest-client'

module ComponentServices
  module OpenWeatherMap
    URL = "http://api.openweathermap.org/data/2.5/"

    def request
      begin
        response = RestClient.get(URL + "weather?lat=#{self.lat}&lon=#{self.lon}&APPID=#{WEATHER_API_KEY}")
        json = JSON.parse(response)
      rescue
        nil
      end
    end

    def collect_temperature
      self.request["main"]["temp"]
    end

    def collect_pressure
      self.request["main"]["pressure"]
    end

    def collect_humidity
      self.request["main"]["humidity"]
    end

    def collect_manipulate_led
      nil
    end
  end
end
