require 'json'
require 'rest-client'

module ExternalAPI
  module OpenWeatherMap
    URL = "http://api.openweathermap.org/data/2.5/"

    def get_temperature
      begin
        response = RestClient.get(URL + "weather?lat=#{self.lat}&lon=#{self.lon}&APPID=#{WEATHER_API_KEY}")
        json = JSON.parse(response)
        json["main"]["temp"]
      rescue
        nil
      end
    end
  end
end
