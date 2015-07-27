require 'onepagecrm/version'
require 'base64'
require 'json'
require 'faraday'

# OnePageCRM API Client Object
class OnePageCRM
  def initialize(login = nil, password = nil)
    @url = 'https://app.onepagecrm.com/api/v3/'
    @conn = Faraday.new(url: @url)
    log_in(login, password)
  end

  # Log user into API
  def log_in(login, password)
    params = { login: login, password: password }
    auth_data = post('login.json', params)
    @uid = auth_data['data']['user_id']
    @auth_key = Base64.decode64(auth_data['data']['auth_key'])
  end

  # defines get and delete methods
  %w(get delete).each do |http_method|
    define_method http_method do |endpoint, params = {}|
      @conn.headers = auth_header(http_method, @url + endpoint, params)
      response = @conn.send(http_method, endpoint, params)
      JSON.parse response.body
    end
  end

  # Defines put and post methods
  %w(post put).each do |http_method|
    define_method http_method do |endpoint, params = {}|
      @conn.headers = auth_header(http_method, @url + endpoint, params)
      response = @conn.send(http_method, endpoint, params.to_json)
      JSON.parse response.body
    end
  end

  # Returns headers required for API authentication
  def auth_header(http_method, url, parameters)
    http_method = http_method.upcase
    op_headers = { 'Content-Type' => 'application/json' }
    return op_headers if @uid.nil? || @auth_key.nil?
    if parameters.any? && %w(GET DELETE).include?(http_method)
      url += '?' + URI.encode_www_form(parameters)
    end

    timestamp = Time.now.to_i.to_s
    token = create_auth_token(http_method, url, parameters, timestamp)
    { 'X-OnePageCRM-UID' => @uid,
      'X-OnePageCRM-TS' => timestamp,
      'X-OnePageCRM-Auth' => token,
      'X-OnePageCRM-Source' => 'ruby_gem'
     }.merge op_headers
  end

  # Creates the auth token for the X-OnePageCRM-Auth header
  def create_auth_token(http_method, request_url, request_body, timestamp)
    request_url_hash = Digest::SHA1.hexdigest request_url
    request_body_hash = Digest::SHA1.hexdigest request_body.to_json
    signature = [@uid, timestamp, http_method.upcase, request_url_hash].join '.'
    signature += ('.' + request_body_hash) if %w(POST PUT).include?(http_method)
    OpenSSL::HMAC.hexdigest('sha256', @auth_key, signature).to_s
  end
end
