class ActuatorsController < ApplicationController
  
  # POST /subscriptions/
  def subscribe
    uuid = subscription_params["uuid"]
    url = subscription_params["url"]
    capabilities = subscription_params["capabilities"]

    if url.nil? || uuid.nil?
      render error_payload("'url' and 'uuid' are required parameters", 422)
      return
    end

    response = Platform::ResourceManager.get_resource(uuid)
    if response.nil?
      render error_payload("Resource Cataloguer service is unavailable", 503)
      return
    elsif response.code != 200
      render json: response.body, status: response.code
      return
    end

    available_capabilities = JSON.parse(response.body)["data"]["capabilities"]
    match_capabilities = available_capabilities & capabilities
    if match_capabilities.blank?
      render json: {error: "This resource does not have these capabilities: #{capabilities - match_capabilities}"}, status: 404
      return
    end

    subscription = Subscription.new(subscription_params)
    if subscription.save
      render json: subscription, status: 200
    else
      render json: {error: "Could not create subscription"}, status: 422
    end
  end

  private

    def subscription_params
      params.require(:subscription).permit(:uuid, :url, capabilities: [])
    end
end
