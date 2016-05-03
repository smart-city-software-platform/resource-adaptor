class ComponentsController < ApplicationController
  before_action :set_basic_resource
  before_action :set_component, only: [:show, :update, :destroy]

  # GET /basic_resources/1/components/
  def index
    @components = @basic_resource.components

    render json: @components
  end

  # GET /basic_resources/1/components/1
  def show
    render json: @component
  end

  private

    def set_component
      begin
        @component = Component.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render error_payload("No such component", 404)
      end
    end

    def component_params
      params[:component]
    end

    def set_basic_resource
      begin
        @basic_resource = BasicResource.find(params[:basic_resource_id])
      rescue ActiveRecord::RecordNotFound
        render error_payload("No such resource", 404)
      end
    end

    def basic_resource_params
      params[:basic_resource]
    end
end
