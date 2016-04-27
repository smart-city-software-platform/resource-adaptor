class BasicResourcesController < ApplicationController
  before_action :set_basic_resource, only: [:show, :update, :destroy]

  # GET /basic_resources
  # GET /basic_resources.json
  def index
    @basic_resources = BasicResource.all

    render json: @basic_resources
  end

  # GET /basic_resources/1
  # GET /basic_resources/1.json
  def show
    render json: @basic_resource
  end

  # POST /basic_resources
  # POST /basic_resources.json
  def create
    @basic_resource = BasicResource.new(basic_resource_params)

    if @basic_resource.save
      render json: @basic_resource, status: :created, location: @basic_resource
    else
      render json: @basic_resource.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /basic_resources/1
  # PATCH/PUT /basic_resources/1.json
  def update
    @basic_resource = BasicResource.find(params[:id])

    if @basic_resource.update(basic_resource_params)
      head :no_content
    else
      render json: @basic_resource.errors, status: :unprocessable_entity
    end
  end

  # DELETE /basic_resources/1
  # DELETE /basic_resources/1.json
  def destroy
    @basic_resource.destroy

    head :no_content
  end

  private

    def set_basic_resource
      @basic_resource = BasicResource.find(params[:id])
    end

    def basic_resource_params
      params[:basic_resource]
    end
end
