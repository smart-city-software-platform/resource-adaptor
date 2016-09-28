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

  desc 'Create components with lib/seeds scripts'
  task :seed, [:file_name, :needs] => [:environment] do |t, args|
    if args[:file_name]
      system("bundle exec rails runner #{Rails.root.join('lib/seeds', args[:file_name])}")
    else
      Dir.glob(Rails.root.join('lib/seeds/*.rb')) do |file|
        system("bundle exec rails runner #{file}")
      end
    end
  end
end

