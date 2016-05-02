class ComponentsController < ApplicationController
  before_action :set_component, only: [:show, :update, :destroy]

  # GET /components
  # GET /components.json
  def index
    @components = Component.all

    render json: @components
  end

  # GET /components/1
  # GET /components/1.json
  def show
    render json: @component
  end

  def new
    render json: {error: 404}
  end

  private

    def set_component
      @component = Component.find(params[:id])
    end

    def component_params
      params[:component]
    end
end
