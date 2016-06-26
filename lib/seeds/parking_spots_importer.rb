##
# Create components for each parking spot that will be simulated.
#

require 'yaml'

SPOT_DEFAULTS = {
  collect_interval: 10,  # seconds
  service_type: 'ParkingSpot',
  capabilities: [
    'spot_availability',
    'availability_schedules'
  ]
}

data = YAML.load(File.read(Rails.root.join(*%w(files parking_spots.yml))))

count = 0
puts 'Importing parking spots data:'

data['spots'].each do |spot|
  component = Component.new(
    SPOT_DEFAULTS.merge(
      lat: spot['latitude'],
      lon: spot['longitude'],
    )
  )

  # Add collect_* methods to object.
  klass = "ComponentServices::#{component.service_type}".constantize
  component.send(:extend, klass)

  component.last_collection['availability_schedules'] =
    spot['availability_schedules'].to_json

  component.last_collection['spot_availability'] =
    component.collect_spot_availability

  if component.save
    print '.'
    count += 1
  else
    print 'F'
  end
end

puts
puts "#{count} components created!"
