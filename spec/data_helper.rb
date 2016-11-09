module DataHelper
  def create_resources(components = 3)
    (1..components).each do |i|
      Component.create!(
        description: "Text #{i}",
        service_type: 'Foo',
        lat: (-23 + i/10.0),
        lon: (-46 + i/10.0),
        collect_interval: 60,
        capabilities: ["temperature", "humidity"]
      )
    end
  end
end
