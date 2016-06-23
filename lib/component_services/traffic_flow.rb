module ComponentServices
  ##

  module TrafficFlow

    def collect_traffic_speed
      if self.current_data['traffic_light_status'] #green status
        previous_speed = self.current_data['traffic_speed']
        speed = previous_speed
        speed = speed + Random.rand(0...15)
        speed = speed - Random.rand(0...4)
      else #red status
        speed = 0
      end
      speed = 60 if speed > 60
      speed = 0 if speed < 0
      speed
    end 

    def collect_traffic_density
      previous_density = self.current_data['traffic_density']
      if self.current_data['traffic_light_status'] #green status
        density = previous_density
        density = density + Random.rand(0...6)
        density = density - Random.rand(0...6)
      else #red status
        density = previous_density + Random.rand(0...2)
      end
      density = 10 if density > 10
      density = 0 if density < 0
      density
    end

    def collect_traffic_light_status
      self.current_data['traffic_light_status']
    end
  end
end
