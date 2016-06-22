require 'csv'
#require '../config/environment'
 
cont = 0

puts "Importing gree area data from GeoSampa file:"

csv_text = File.open(Rails.root.join("files", "green_area.csv"),"r:ISO-8859-1")
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  lat = row["LAT"].to_s
  lat = lat[0..2] + '.' + lat[3..-1]
  lon = row["LONG"]
  lon = lon[0..2] + '.' + lon[3..-1]
  component = Component.new(lat: lat.to_f, lon: lon.to_f, collect_interval: 60, service_type: "SportsMaps", capabilities: ['temperature', 'humidity', 'uv', 'pollution', 'info_green_percentage'])
  component.last_collection['info_green_percentage'] = Random.rand(0..100)
  if component.save
    print '.'
    cont = cont + 1
  else
    print 'F'
  end
end

puts "\n#{cont} components created!"
