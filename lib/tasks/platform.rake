namespace :component do
  desc "Create all resources and components in local database"
  task :create => :environment do
    begin
      Platform::ResourceManager.create_all
      puts "#{BasicResource.count} resources and #{Component.count} components created!"
    rescue
      puts "An error has occurred while trying to create Components"
      puts "Please, verify the resource configuration file"
    end
  end

  desc "Register all resources and components in the Platform"
  task :register => :environment do
    registered = Platform::ResourceManager.register_all
    puts "#{registered} components registered!"
  end

  desc "Update all registered resources and components in the Platform"
  task :update, [:capability_name, :needs] => [:environment] do |t, args|
    capability = ''
    if args[:capability_name]
      capability = args[:capability_name]
    end

    updated = Platform::ResourceManager.update(capability)
    puts "#{updated} components updated!"
  end

  desc 'Create components with lib/seeds scripts'
  task :seed, [:file_name, :needs] => [:environment] do |t, args|
    resource = BasicResource.first.nil? ? BasicResource.create! : BasicResource.first

    if args[:file_name]
      system("bundle exec rails runner #{Rails.root.join('lib/seeds', args[:file_name])}")
    else
      Dir.glob(Rails.root.join('lib/seeds/*.rb')) do |file|
        system("bundle exec rails runner #{file}")
      end
    end

    Component.update_all(basic_resource_id: resource.id)
  end
end

