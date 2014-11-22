require 'onepagecrm/version'
require 'net/http'
require 'openssl'
require 'base64'
require 'json'
require 'uri'

class Onepagecrm
  def initialize(login = nil, password = nil)
    @url = 'https://app.onepagecrm.com/api/v3/'
    log_in(login, password)
  end

  # Login user into API
  def log_in(login, password)
    params = { login: login, password: password }
    auth_data = post('login.json', params)
    @uid = auth_data['data']['user_id']
    @api_key = Base64.decode64(auth_data['data']['auth_key'])
  end

  # Send GET request
  def get(method, params = {})
    url = URI.parse(@url + method)
    req = Net::HTTP::Get.new(url.request_uri)
    add_auth_headers(req, 'GET', method, params)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    result = http.request(req).body
    JSON.parse result
  end

    # Send DELETE request
  def delete(method, params = {})
    url = URI.parse(@url + method)
    req = Net::HTTP::Delete.new(url.request_uri)
    add_auth_headers(req, 'DELETE', method, params)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    result = http.request(req).body
    JSON.parse result
  end

  # Send POST request
  def post(method, params = {})
    url = URI.parse(@url + method)
    req = Net::HTTP::Post.new(url.path)
    req.body = params.to_json
    req.add_field('Content-Type', 'application/json; charset=utf-8')
    add_auth_headers(req, 'POST', method, params)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    result = http.request(req).body
    JSON.parse result
  end

  # Send PUT request
  def put(method, params = {})
    url = URI.parse(@url + method)
    req = Net::HTTP::Put.new(url.path)
    req.body = params.to_json
    req.add_field('Content-Type', 'application/json; charset=utf-8')
    add_auth_headers(req, 'PUT', method, params)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    result = http.request(req).body
    JSON.parse result
  end

  # Add authentication headers
  def add_auth_headers(req, http_method, api_method, params)
    return if @uid.nil? || @api_key.nil?

    url_to_sign = @url + api_method
    params_to_sign = params.empty? ? nil : URI.encode_www_form(params)
    url_to_sign += '?' + params_to_sign unless params_to_sign.nil? || %w(POST PUT).include?(http_method)

    # puts url_to_sign
    timestamp = Time.now.to_i.to_s
    token = create_token(timestamp, http_method, url_to_sign, params)

    req.add_field('X-OnePageCRM-UID', @uid)
    req.add_field('X-OnePageCRM-TS', timestamp)
    req.add_field('X-OnePageCRM-Auth', token)
    req.add_field('X-OnePageCRM-Source', 'lead_clip_chrome')
  end

  # Creates the token for X-OnePageCRM-Auth
  def create_token(timestamp, request_type, request_url, request_body)
    request_url_hash = Digest::SHA1.hexdigest request_url
    request_body_hash = Digest::SHA1.hexdigest request_body.to_json
    signature_message = [@uid, timestamp, request_type.upcase, request_url_hash].join '.'
    signature_message += ('.' + request_body_hash) unless request_body.empty?
    OpenSSL::HMAC.hexdigest('sha256', @api_key, signature_message).to_s
  end
end
