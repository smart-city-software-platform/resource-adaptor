require 'colorize'

system "clear"

def help
  puts "### Commands ###".yellow.bold
  puts "* status:".bold + " print the status of all collecting components' threads"
  puts "* start_all:".bold + " start all components collection"
  puts "* start_component 12:".bold + " start the collection of component with id 12"
  puts "* stop_all:".bold + " stop all components collection"
  puts "* stop_component 10:".bold + "stop the collection of component with id 10"
end

manager = ComponentsManager.instance
puts "="*50
puts "Start the collection of data...".yellow.bold
puts "="*50
manager.start_all

loop do
  STDOUT.flush

  print "Type help to list commands or request a command: "
  input = gets
  break if input.nil? 
    
  command, *params = input.chomp.split /\s/

  begin
    puts "="*50
    case command
    when "clear"
      system "clear"
    when "help"
      help
    when "start_all"
      puts "All components alread running".green
      manager.start_all
    when "start_component"
      id = params.first.to_i
      manager.start_component(id)
      puts "Requested processed: Component #{Component.find(id).status}".green
    when "stop_all"
      manager.stop_all
      puts "All components stoped".green
    when "stop_component"
      puts "="*100, params.first, params.first.to_i
      manager.stop_component(params.first.to_i)
      puts "Requested processed: Component #{Component.find(id).status}".green
    when "status"
      puts "STATUS".green
      puts manager.status
    else
      puts "Command not recognized".light_red.bold
    end
    puts "="*50
  rescue
    puts "!!!!! Error while processing the request !!!!!".red.bold
  end
end


puts "\nStopping all components...".yellow
manager.stop_all
