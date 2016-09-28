require 'csv'
#require '../config/environment'

cont = 0

puts "Importing Bus Lines data from Olho Vivo API data file:"

csv_text = File.open(Rails.root.join("files", "bus_lines.csv"),"r")

CSV.parse(csv_text, :headers => true).each do |row|
  component = Component.new(lat: nil, lon: nil, collect_interval: 40, service_type: "BusLine", capabilities: ['current_buses', 'info_code'])
  component.last_collection['current_buses'] = 0
  component.last_collection['info_code'] = row['code']
  if component.save
    print '.'
    cont = cont + 1
  else
    print 'F'
  end
end

puts "\n#{cont} components created!"
