require 'json'
require 'rest-client'

module ExternalAPI
  module OpenWeatherMap
    URL = "http://api.openweathermap.org/data/2.5/"

    def get_temperature
      response = RestClient.get(URL + "weather?lat=#{self.lat}&lon=#{self.lon}&APPID=#{WEATHER_API_KEY}")
      json = JSON.parse(response)
      original = from_kelvin_to_celsius(json["main"]["temp"])
    end

    def from_kelvin_to_celsius(temperature)
      temperature - 273.15
    end
  end
end
