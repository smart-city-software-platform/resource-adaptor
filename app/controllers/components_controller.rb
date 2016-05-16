class ComponentsController < ApplicationController
  before_action :set_basic_resource
  before_action :set_component, only: [:show, :collect_specific, :collect]
  before_action :set_capability, only: [:collect_specific]

  # GET /basic_resources/1/components/
  def index
    @components = @basic_resource.components

    render json: @components
  end

  # GET /basic_resources/1/components/status
  def status
    @components = @basic_resource.components

    render json: @components.map { |component| {id: component.id, status: component.status, updated_at: component.updated_at} }
  end

  # GET /basic_resources/1/components/1
  def show
    render json: {data: @component}
  end

  # GET /basic_resources/1/components/1/collect/temperature
  def collect_specific
    begin
      render json: {data: @component.send(@capability), updated_at: @component.updated_at}
    rescue
      render error_payload("Error while processing the requested capability", 422)
    end
  end

  # GET /basic_resources/1/components/1/collect
  def collect
    begin
      values = {}
      @component.capabilities.each do |cap|
        values[cap.to_s] = @component.send(cap.to_s)
      end
      render json: {data: values, updated_at: @component.updated_at}
    rescue
      render error_payload("Error while processing the data collection", 500)
    end
  end

  private

    def set_component
      begin
        @component = Component.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render error_payload("No such component", 404)
      end
    end

    def set_basic_resource
      begin
        @basic_resource = BasicResource.find(params[:basic_resource_id])
      rescue ActiveRecord::RecordNotFound
        render error_payload("No such resource", 404)
      end
    end

    def set_capability
      @capability = params[:capability]
      unless @component.capabilities.include?(@capability)
        render error_payload("The required component does not respond to such capability", 422)
      end
    end
end
