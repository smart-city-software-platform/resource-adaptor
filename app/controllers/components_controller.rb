class ComponentsController < ApplicationController
  before_action :set_component, only: [:show, :collect_specific, :collect, :data_specific, :data, :actuate]
  before_action :set_capability, only: [:collect_specific, :actuate, :data_specific]

  # GET /components/
  def index
    @components = Component.all

    render json: @components
  end

  # GET /components/status
  def status
    @components = Component.all

    render json: @components.map { |component| {id: component.id, status: component.status, updated_at: Time.now.utc} }
  end

  # GET /components/1
  def show
    render json: {data: @component}
  end

  # GET /components/1/collect/temperature
  def collect_specific
    begin
      render json: {data: @component.send(@capability), updated_at: Time.now.utc}
    rescue
      render error_payload("Error while processing the requested capability", 422)
    end
  end

  # GET /components/1/collect
  def collect
    begin
      values = {}
      @component.capabilities.each do |cap|
        values[cap.to_s] = @component.send(cap.to_s)
      end
      render json: {data: values, updated_at: Time.now.utc}
    rescue
      render error_payload("Error while processing the data collection", 500)
    end
  end

  # POST /components/1/data/
  def data
    data_manager = DataManager.instance
    data_params.each do |capability_name, value|
      data_manager.publish_resource_data(@component, capability_name, value.first)
      @component.observations[capability_name] = value.first
    end

    render status: 201, json: {}
  end

  # POST /components/1/data/temperature
  def data_specific
    @component.observations[@capability] = data_params.first
    render status: 201, json: {}
  end

  # PUT /components/1/actuate/traffic_light_status
  def actuate
      actuate_method = @capability.to_s
      render json: {data: {state: actuator_params[:value], updated_at: Time.now.utc}}
  end

  private

    def actuator_params
      params.require(:data).permit(:value)
    end

    def data_params
      params.require(:data)
    end

    def set_component
      begin
        @component = Component.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render error_payload("No such component", 404)
      end
    end

    def set_capability
      @capability = params[:capability]
      unless @component.capabilities.include?(@capability)
        render error_payload("The required component does not respond to such capability", 422)
      end
    end
end
