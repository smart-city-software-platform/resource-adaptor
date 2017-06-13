require 'rubygems'
require 'json'
require 'rest-client'

class WebHookCaller
  include Sidekiq::Worker
  sidekiq_options queue: 'web_hook_caller', backtrace: true

  def perform(id, url, body)
    command = JSON.parse(body).slice(
      'uuid',
      'capability',
      'created_at',
      'value',
    )
    command['url'] = url

    begin
      response = RestClient.post(
        url,
        {action: 'actuator_command', command: command}.to_json,
        {content_type: :json, accept: :json}
      )

      WORKERS_LOGGER.info("WebHookCaller::CommandSend - notification_id: #{id}, url: #{url}")
    rescue RestClient::ExceptionWithResponse => e
      WORKERS_LOGGER.error("WebHookCaller::CommandNotSend - notification_id: #{id}, url: #{url}, error: #{e.message}")
    rescue StandardError => e
      WORKERS_LOGGER.error("WebHookCaller::CommandNotSend - notification_id: #{id}, url: #{url}, error: #{e.message}")
      raise e # This will make sidekiq to retry again later
    end
  end
end
