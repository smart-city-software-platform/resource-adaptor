module ComponentServices
  ##

  module ArduinoDemo

    def collect_arduino_luminosity
      self.current_data['arduino_luminosity']
    end 

    def collect_arduino_traffic_light
      self.current_data['arduino_traffic_light']
    end

    def actuate_arduino_traffic_light(status)
      if status == true || status =~ (/^(true|t|green|g|1)$/i)
        self.current_data['arduino_traffic_light'] = 'green'
      elsif status == false || status =~ (/^(false|f|red|r|0)$/i)
        self.current_data['arduino_traffic_light'] = 'red'
      elsif status && status =~ (/^(y|yellow|2)$/i)
        self.current_data['arduino_traffic_light'] = 'yellow'
      else
        nil
      end
    end

    def actuate_arduino_luminosity(value)
      if value  
        self.current_data['arduino_luminosity'] = value
      else
        nil
      end
    end
  end
end
