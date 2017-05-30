class ActuatorsController < ApplicationController
  
  # POST /subscriptions/
  def subscribe
    uuid = subscription_params["uuid"]
    url = subscription_params["url"]
    capabilities = subscription_params["capabilities"]

    if url.nil? || uuid.nil? || capabilities.blank?
      render json: {error: "'url', 'uuid', and 'capabilities' are required parameters"}, status: 422
      return
    end

    response = Platform::ResourceManager.get_resource(uuid)
    if response.nil?
      render json: {error: "Resource Cataloguer service is unavailable"},  status: 503
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

    subscription = Subscription.create(subscription_params)
    render json: subscription, status: 201
  end

  private

    def subscription_params
      params.require(:subscription).permit(:uuid, :url, capabilities: [])
    end
end
