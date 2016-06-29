#require 'config/environment'
cont = 0
puts "Importing arduino data:"

component = Component.new(id: '100000', description:"Ardunio", service_type:"ArduinoDemo", collect_interval: 2, 
  capabilities:["arduino_traffic_light", "arduino_luminosity"], 
  lat: -23.558658, lon: -46.730811)
component.last_collection['arduino_luminosity'] = 0
component.last_collection['arduino_traffic_light'] = 'green'

if component.save
  print '.'
  cont = cont + 1
else
  print 'F'
end
puts "\n#{cont} components created!"

# traffic_lights_list.each do |tl|
#   Component.create!(description:"", service_type:"TrafficLight", collect_interval:2,
#     capabilities:["traffic_light_state"], lat:tl.first, lon:tl.last)
# end
