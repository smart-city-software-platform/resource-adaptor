class BasicResourcesController < ApplicationController
  before_action :set_basic_resource, only: [:show, :update, :destroy]

  # GET /basic_resources
  def index
    @basic_resources = BasicResource.all

    render json: @basic_resources
  end

  # GET /basic_resources/1
  def show
    render json: @basic_resource.meta_data
  end

  private

    def set_basic_resource
      begin
        @basic_resource = BasicResource.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render error_payload("No such resource", 404)
      end
    end

    def basic_resource_params
      params[:basic_resource]
    end
end
