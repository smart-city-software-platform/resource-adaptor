namespace :component do
  desc "Register all resources in the Platform"
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
end

