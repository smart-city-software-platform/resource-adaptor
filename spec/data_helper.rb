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
          localization: "Somewhere"
        )
      end
    end
  end
end
