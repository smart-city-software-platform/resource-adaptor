Rails.application.load_seed if Component.count == 0

json = {
  url: "/ip/",
  tipo: "Arduíno",
  modelo: "Uno",
  fabricante: "XPTO",
  n_componentes: 0,
  componentes: []
}

Component.all.each do |component|
  json[:n_componentes] = json[:n_componentes] + 1 
  # Registra no Catálogo como recurso
  json[:componentes] << {id: component.id}
end

puts "HTTP POST url_do_catalogo/resource/registry/"
puts json

