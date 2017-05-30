class ActuatorsController < ApplicationController
  before_action :set_subscription, only: [:update, :destroy]

  # POST /subscriptions/
  def subscribe
    @subscription = Subscription.new(subscription_params)

    unless @subscription.valid?
      render json: {error: @subscription.errors.full_messages}, status: 422
      return
    end

    response = Platform::ResourceManager.get_resource(@subscription.uuid)
    if response.nil?
      render json: {error: "Resource Cataloguer service is unavailable"},  status: 503
      return
    elsif response.code != 200
      render json: response.body, status: response.code
      return
    end

    available_capabilities = JSON.parse(response.body)["data"]["capabilities"]
    match_capabilities = available_capabilities & @subscription.capabilities
    if match_capabilities.blank?
      render json: {error: "This resource does not have these capabilities: #{@subscription.capabilities - match_capabilities}"}, status: 404
      return
    end

    @subscription.save!
    render json: {subscription: @subscription}, status: 201
  end

  # PUT /subscriptions/:id
  def update
    @subscription.assign_attributes(subscription_params)

    unless @subscription.valid?
      render json: {error: @subscription.errors.full_messages}, status: 422
      return
    end

    response = Platform::ResourceManager.get_resource(@subscription.uuid)
    if response.nil?
      render json: {error: "Resource Cataloguer service is unavailable"},  status: 503
      return
    elsif response.code != 200
      render json: response.body, status: response.code
      return
    end

    available_capabilities = JSON.parse(response.body)["data"]["capabilities"]
    match_capabilities = available_capabilities & @subscription.capabilities
    if match_capabilities.blank?
      render json: {error: "This resource does not have these capabilities: #{@subscription.capabilities - match_capabilities}"}, status: 404
      return
    end

    @subscription.save!
    render json: {subscription: @subscription}, status: 200
  end

  # DELETE /subscriptions/:id
  def destroy
    @subscription.destroy
    render json: nil, head: :no_content, status: 204
  end

  private

    def subscription_params
      params.require(:subscription).permit(:uuid, :url, capabilities: [])
    end

    def set_subscription
      @subscription = Subscription.find(params["id"])
    rescue ActiveRecord::RecordNotFound
      render json: {error: "Subscription not found"}, status: 404
      return
    end
end
