class ComponentsController < ApplicationController
  before_action :set_component, only: [:show, :collect_specific, :collect, :actuate]
  before_action :set_capability, only: [:collect_specific, :actuate]

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

  # PUT /components/1/actuate/traffic_light_status
  def actuate
    begin
      service = "ComponentServices::" + @component.service_type
      @component.extend(service.constantize)
      actuate_method = 'actuate_' + @capability.to_s
      unless @component.respond_to? actuate_method
        render error_payload("Impossible to actuate over the required capability", 405) and return
      end

      result = @component.send(actuate_method, actuator_params[:value])

      if result.nil?
        render error_payload("The required component can not actuate with received parameters", 422) and return
      end

      render json: {data: {state: result, updated_at: Time.now.utc}}
    rescue
      render error_payload("Error while actuating on device", 500)
    end
  end

  private

    def actuator_params
      params.require(:data).permit(:value)
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
