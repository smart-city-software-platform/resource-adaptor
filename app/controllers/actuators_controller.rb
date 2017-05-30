class ActuatorsController < ApplicationController
  
  # POST /subscriptions/
  def subscribe
    subscription = Subscription.new(subscription_params)

    unless subscription.valid?
      render json: {error: subscription.errors.full_messages}, status: 422
      return
    end

    response = Platform::ResourceManager.get_resource(subscription.uuid)
    if response.nil?
      render json: {error: "Resource Cataloguer service is unavailable"},  status: 503
      return
    elsif response.code != 200
      render json: response.body, status: response.code
      return
    end

    available_capabilities = JSON.parse(response.body)["data"]["capabilities"]
    match_capabilities = available_capabilities & subscription.capabilities
    if match_capabilities.blank?
      render json: {error: "This resource does not have these capabilities: #{subscription.capabilities - match_capabilities}"}, status: 404
      return
    end

    subscription.save!
    render json: subscription, status: 201
  end

  private

    def subscription_params
      params.require(:subscription).permit(:uuid, :url, capabilities: [])
    end
end
