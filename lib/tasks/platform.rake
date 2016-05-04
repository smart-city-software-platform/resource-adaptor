namespace :platform do
  desc "Register all resources and components in the Platform"
  task :register => :environment do
    begin
      Platform::ResourceManager.register_resources
      puts "#{BasicResource.count} resources and #{Component.count} components registered!"
    rescue
      puts "An error has occurred while trying to register in the platform"
      puts "Please, verify the services configuration file"
    end
  end
end
