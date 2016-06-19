require 'json'
require 'rest-client'

module ComponentServices
  ##
  # Implement methods to read data from spot availability sensors.
  # Note: since we do not have access to a real parking data API,
  # all data in this module will be randomly generated.
  module SportsMaps
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

    def collect_humidity
      self.request["main"]["humidity"]
    end
    
    def collect_uv
      Random.rand(0..15)
    end
    
    def collect_pollution
        Random.rand(0..500)
    end
    
    def collect_green_areas
        self.last_collection['info_green_percentage']
    end
  end
end