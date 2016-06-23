#require 'config/environment'

sensors_list = [
    [-23.55659, -46.662111],
    [-23.555706, -46.662745],
    [-23.556636, -46.662109],
    [-23.555463, -46.66081],
    [-23.557386, -46.66119],
    [-23.556477, -46.661893],
    [-23.557291, -46.661017],
    [-23.558235, -46.662029],
    [-23.558153, -46.660291],
    [-23.557338, -46.661032],
    [-23.558197, -46.660292],
    [-23.556974, -46.659003],
    [-23.560085, -46.658179],
    [-23.558106, -46.660125],
    [-23.560133, -46.658175],
    [-23.558378, -46.656323],
    [-23.560991, -46.657205],
    [-23.560042, -46.658029],
    [-23.560887, -46.657055],
    [-23.561792, -46.657987],
    [-23.562072, -46.655923],
    [-23.560928, -46.657053],
    [-23.562115, -46.655911],
    [-23.561626, -46.655437],
    [-23.563732, -46.653834],
    [-23.561969, -46.655765],
    [-23.563633, -46.653695],
    [-23.564656, -46.654657],
    [-23.564965, -46.652362],
    [-23.56367, -46.653694],
    [-23.565005, -46.652357],
    [-23.563968, -46.651346],
    [-23.56621, -46.650942],
    [-23.56491, -46.652214],
    [-23.566091, -46.650792],
    [-23.567078, -46.651781],
    [-23.567705, -46.649081],
    [-23.566132, -46.65079],
    [-23.56775, -46.649077],
    [-23.566495, -46.648329],
    [-23.569023, -46.647496],
    [-23.56762, -46.64896],
    [-23.568844, -46.647304],
    [-23.569908, -46.648328],
    [-23.569633, -46.646637],
    [-23.568883, -46.647305],
    [-23.569671, -46.646633],
    [-23.56871, -46.645678],
    [-23.571334, -46.644348],
    [-23.569535, -46.646447],
    [-23.571236, -46.644203],
    [-23.571756, -46.64447]
]

traffic_lights_list = [
    [-23.556378, -46.662010], #paulista w/ bela cintra (consolação)
    [-23.556692, -46.662028], #paulista w/ bela cintra (paraíso)
    [-23.556358, -46.661807], #paulista w/ bela cintra (downtown)
    [-23.557157, -46.661116], #paulista w/ haddock lobo (consolação)
    [-23.557493, -46.661046], #paulista w/ haddock lobo (paraíso)
    [-23.557532, -46.661294], #paulista w/ haddock lobo (suburb)
    [-23.558000, -46.660240], #paulista w/ augusta (consolação)
    [-23.558225, -46.660198], #paulista w/ augusta (paraíso)
    [-23.558036, -46.660074], #paulista w/ augusta (downtown)
    [-23.558264, -46.660417], #paulista w/ augusta (suburb)
    [-23.559972, -46.658111], #paulista w/ min. rocha azevedo (consolação)
    [-23.560147, -46.658117], #paulista w/ min. rocha azevedo (paraíso)
    [-23.559975, -46.658006], #paulista w/ min. rocha azevedo (downtown)
    [-23.560859, -46.657130], #paulista w/ peixoto gomide (consolação)
    [-23.561054, -46.657133], #paulista w/ peixoto gomide (paraíso)
    [-23.561063, -46.657246], #paulista w/ peixoto gomide (suburb)
    [-23.561905, -46.655847], #paulista w/ casa branca (consolação)
    [-23.562123, -46.655858], #paulista w/ casa branca (paraíso)
    [-23.561897, -46.655744], #paulista w/ casa branca (downtown)
    [-23.563604, -46.653778], #paulista w/ pamplona (consolação)
    [-23.563795, -46.653761], #paulista w/ pamplona (paraíso)
    [-23.563797, -46.653859], #paulista w/ pamplona (suburb)
    [-23.564846, -46.652285], #paulista w/ campinas (consolação)
    [-23.565026, -46.652294], #paulista w/ campinas (paraíso)
    [-23.564843, -46.652194], #paulista w/ campinas (downtown)
    [-23.566064, -46.650875], #paulista w/ joaquim eugenio (consolação)
    [-23.566267, -46.650877], #paulista w/ joaquim eugenio (paraíso)
    [-23.566275, -46.650965], #paulista w/ joaquim eugenio (suburb)
    [-23.567803, -46.648983], #paulista w/ brigadeiro (consolação)
    [-23.567540, -46.649062], #paulista w/ brigadeiro (paraíso)
    [-23.567526, -46.648916], #paulista w/ brigadeiro (downtown)
    [-23.567817, -46.649155], #paulista w/ brigadeiro (suburb)
    [-23.568841, -46.647356], #paulista w/ carlos sampaio (consolação)
    [-23.569063, -46.647446], #paulista w/ carlos sampaio (paraíso)
    [-23.569067, -46.647491], #paulista w/ carlos sampaio (suburb)
    [-23.569492, -46.646506], #paulista w/ teixeira da silva (consolação)
    [-23.569671, -46.646589], #paulista w/ teixeira da silva (paraíso)
    [-23.569491, -46.646446], #paulista w/ teixeira da silva (downtown)
    [-23.571210, -46.644281], #paulista w/ treze de maio (consolação)
    [-23.571392, -46.644269], #paulista w/ treze de maio (paraíso)
    [-23.571397, -46.644356]  #paulista w/ treze de maio (suburb)
]

cont = 0
puts "Importing traffic light data:"

sensors_list.each do |sensor|
  component = Component.new(description:"", service_type:"TrafficFlow", collect_interval:2, 
    capabilities:["traffic_speed", "traffic_density", "traffic_light_status"], 
    lat:sensor.first, lon:sensor.last)
  component.last_collection['traffic_speed'] = 0
  component.last_collection['traffic_density'] = 0
  component.last_collection['traffic_light_status'] = true

  if component.save
    print '.'
    cont = cont + 1
  else
    print 'F'
  end
end
puts "\n#{cont} components created!"

# traffic_lights_list.each do |tl|
#   Component.create!(description:"", service_type:"TrafficLight", collect_interval:2,
#     capabilities:["traffic_light_state"], lat:tl.first, lon:tl.last)
# end
