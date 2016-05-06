class ComponentsManager
  include Singleton
  
  def initialize
    @component_threads = []
  end

  def start_all
    Component.find_each do |component|
      data = {id: component.id}
      data[:thread] = component.perform
      @component_threads << data
    end
  end

  def start_component(id)
    register = @component_threads.find {|register| register[:id] == id}
    if register.nil? || !register[:thread].status
      component = Component.find id
      component.perform
    end 
  end

  def stop_all
    @component_threads.each do |register|
      register[:thread].kill
    end

    Component.update_all("status = 'stoped'")
  end

  def stop_component(id)
    register = @component_threads.find {|register| register[:id] == id}
    if !register.nil? && register[:thread].status 
      register[:thread].kill
      Component.update(id, status: 'stoped')
    end
  end

  def status
    all_status = {}
    @component_threads.each do |register|
      all_status[register[:id]] = register[:thread].status
    end

    all_status
  end

  def running?(thread)
    thread.status == "run" || thread.status == "sleep"
  end
end
