require 'csv'
require '../config/environment'

csv_text = File.open(Rails.root.join("files", "geo_sampa.csv"),"r:ISO-8859-1")
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  puts row
  component = Component.new(lat: row["lat"], lon: row["longi"], collect_interval: 60, service_type: "HealthFacility", capabilities: ['info_facility_type', 'info_total_capacity', 'current_users'])
  component.last_collection['info_facility_type'] = row["typeOf"]
  component.last_collection['info_total_capacity'] = Random.rand(50...500)
  component.save!
end
