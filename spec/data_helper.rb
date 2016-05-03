module DataHelper
  def create_resources(resources = 1, components = 3)
    (1..resources).each do |i|
      resource = BasicResource.create!(
        name: "Arduino",
        model: "Uno",
        maker: "XPTO"
      )

      (1..components).each do |i|
        resource.components << Component.new(
          description: "Text #{i}",
          lat: (-23 + i/10.0),
          lon: (-46 + i/10.0)
        )
      end
    end
  end
end
