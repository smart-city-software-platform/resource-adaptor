require 'csv'
#require '../config/environment'

cont = 0

puts "Importing health facilities data from GeoSampa file:"

csv_text = File.open(Rails.root.join("files", "geo_sampa.csv"),"r:ISO-8859-1")

CSV.parse(csv_text, :headers => true).each do |row|
  component = Component.new(lat: row["lat"], lon: row["longi"], collect_interval: 60, service_type: "HealthFacility", capabilities: ['info_facility_type', 'info_total_capacity', 'current_users'])
  component.last_collection['info_facility_type'] = row["typeOf"]
  component.last_collection['info_total_capacity'] = Random.rand(50...500)
  if component.save
    print '.'
    cont = cont + 1
  else
    print 'F'
  end
end

puts "\n#{cont} components created!"
