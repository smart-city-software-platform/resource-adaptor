class ComponentsManagerController < ApplicationController
  before_action :set_manager
  before_action :set_component, only: [:status, :start, :stop]

  def status
    render json: {data: @manager.status[@component.id]}
  end

  def status_all
    render json: {data: @manager.status}
  end

  def start_all
    @manager.start_all
    redirect_to action: 'status_all'
  end

  def start
    @manager.start_component(@component.id)
    redirect_to action: 'status', component_id: @component.id
  end

  def stop_all
    @manager.stop_all
    redirect_to action: 'status_all'
  end

  def stop
    @manager.stop_component(@component.id)
    redirect_to action: 'status', component_id: @component.id
  end

  private

  def set_manager
    @manager = ComponentsManager.instance
  end

  def set_component
    @component = Component.find(params['component_id'])
  end
end
