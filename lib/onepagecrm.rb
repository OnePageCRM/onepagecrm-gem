require 'onepagecrm/version'
require 'base64'
require 'json'
require 'faraday'

# OnePageCRM API Client Object
class OnePageCRM
  def initialize(user_id, api_key)
    url = 'https://app.onepagecrm.com/api/v3/'
    @conn = Faraday.new(url: url) do |conn|
      conn.adapter Faraday.default_adapter
      conn.basic_auth(user_id, api_key)
      conn.headers.merge!(
        'Content-Type' => 'application/json',
        'X-OnePageCRM-UID' => user_id,
        'X-OnePageCRM-Source' => 'ruby_gem'
      )
    end
  end

  # defines get and delete methods
  %w(get delete).each do |http_method|
    define_method http_method do |endpoint, params = {}|
      response = @conn.send(http_method, endpoint, params)
      JSON.parse response.body
    end
  end

  # Defines put and post methods
  %w(post put).each do |http_method|
    define_method http_method do |endpoint, params = {}|
      response = @conn.send(http_method, endpoint, params.to_json)
      JSON.parse response.body
    end
  end
end
