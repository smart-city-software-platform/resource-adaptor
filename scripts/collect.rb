require 'colorize'

system "clear"

def help
  puts "### Commands ###".yellow.bold
  puts "* status:".bold + " print the status of all collecting components' threads"
  puts "* start:".bold + " start all components collection"
  puts "* start 12:".bold + " start the collection of component with id 12"
  puts "* stop:".bold + " stop all components collection"
  puts "* stop 10:".bold + " stop the collection of component with id 10"
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
    when "start"
      if params.first
        id = params.first.to_i
        manager.start_component(id)
        puts "Requested processed: Component #{id} #{Component.find(id).status}".green
      else
        puts "All components alread running".green
        manager.start_all
      end
    when "stop"
      if params.first
        id = params.first.to_i
        manager.stop_component(id)
        puts "Requested processed: Component #{id} #{Component.find(id).status}".green
      else
        manager.stop_all
        puts "All components stoped".green
      end
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
