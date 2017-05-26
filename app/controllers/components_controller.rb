class ComponentsController < ApplicationController
  before_action :set_component, only: [:data_specific, :data]
  before_action :set_capability, only: [:data_specific]

  # POST /components/
  def create
    response = Platform::ResourceManager.register_resource(resource_params.to_h)
    if response.nil?
      render error_payload("Register service is unavailable", 503)
    else
      render json: response.body, status: response.code
    end
  end

  # PUT /components/:id
  def update
    uuid = params[:id]
    response = Platform::ResourceManager.update_resource(uuid, resource_params.to_h)
    if response.nil?
      render error_payload("Service is unavailable", 503)
    else
      render json: response.body, status: response.code
    end
  end

  # POST /components/1/data/
  def data
    data_manager = DataManager.instance
    data_params.to_unsafe_h.each do |capability_name, value|
      value = value.first if value.class == Array
      data_manager.publish_resource_data(@uuid, capability_name, value)
    end

    render status: 201, json: {}
  end

  # POST /components/:uuid/data/temperature
  def data_specific
    data_manager = DataManager.instance
    data_params.each do |data|
      data_manager.publish_resource_data(@uuid, @capability, data)
    end
    render status: 201, json: {}
  end

  private

    def resource_params
      params.require(:data).permit(:description, :lat, :lon, :status, :collect_interval, :uri, capabilities: [])
    end

    def data_params
      params[:data]
    end

    def set_component
      @uuid = params[:id]
    end

    def set_capability
      @capability = params[:capability]
    end
end
