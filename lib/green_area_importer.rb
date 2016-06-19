require 'csv'
  require '../config/environment'
 
  csv_text = File.open(Rails.root.join("files", "green_area.csv"),"r:ISO-8859-1")
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    puts row
    component = Component.new(lat: row["LAT"], lon: row["LONG"], collect_interval: 60, service_type: "SportsMaps", capabilities: ['info_green_percentage'])
    component.last_collection['info_green_percentage'] = Random.rand(0..100)
    component.save!
  end