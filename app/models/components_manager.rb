class ComponentsManager
  include Singleton
  
  def initialize
    @component_threads = {}
  end

  def start_all
    Component.find_each do |component|
      thread = thread_by_id(component.id)
      unless self.running?(thread)
        @component_threads[component.id] = component.perform
      end
    end
  end

  def start_component(id)
    thread = thread_by_id(id)
    unless self.running?(thread)
      component = Component.find id
      @component_threads[component.id] = component.perform
    end 
  end

  def stop_all
    @component_threads.each do |id, thread|
      thread.kill
    end

    Component.update_all("status = 'stoped'")
  end

  def stop_component(id)
    thread = thread_by_id(id)
    if self.running?(thread)
      thread.kill
      Component.update(id, status: 'stoped')
    end
  end

  def status
    all_status = {}
    @component_threads.each do |id, thread|
        all_status[id] = self.running?(thread) ? "running" : "stoped"
    end

    all_status
  end

  def thread_by_id(id)
    @component_threads[id]
  end

  def running?(thread)
    !thread.nil? && (thread.status == "run" || thread.status == "sleep")
  end
end
