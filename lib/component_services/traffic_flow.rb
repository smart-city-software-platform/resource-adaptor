module ComponentServices
  ##

  module TrafficFlow

    def collect_traffic_speed
      speed = Math.sin((Time.now.sec + id)/10.0).abs*60 #0-60 km/hour
    end 

    def collect_traffic_density
      flux = Math.cos((Time.now.sec + id)/10.0).abs*10 #0-10 vechiles/sec
    end

  end
end
