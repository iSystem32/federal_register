class FederalRegister::Client

  class ResponseError < Faraday::Error

    attr_reader :response

    def initialize(response)
      @response = response
      super(message)
    end

    def message
      response.body
    end

    def to_s
      message
    end
  end

  class BadRequest < ResponseError; end
  class GatewayTimeout < ResponseError; end
  class RecordNotFound < ResponseError; end
  class ServerError < ResponseError; end
  class ServiceUnavailable < ResponseError; end

  FaradayResponseWrapper = Struct.new(:parsed_response)

  def self.base_uri
    'https://www.federalregister.gov/api/v1'
  end

  def self.get(path, options={})
    @connection = Faraday.new(url: base_uri) do |conn|
      conn.request :url_encoded
      conn.response :logger if ENV['DEBUG'] # Optional: Enable logging in debug mode
      conn.adapter Faraday.default_adapter
      conn.options.open_timeout = ENV['FARADAY_OPEN_TIMEOUT'].try(:to_i) || 2
      conn.options.timeout = 10 
    end

    if options[:ignore_base_url]
      response = Faraday.get(path)
    else
      response = @connection.get(path, options[:query] || {})
    end

    case response.status
    when 200
      FaradayResponseWrapper.new(JSON.parse(response.body))
    when 400
      raise BadRequest.new(response)
    when 404
      raise RecordNotFound.new(response)
    when 500
      raise ServerError.new(response)
    when 503
      raise ServiceUnavailable.new(response)
    when 504
      raise GatewayTimeout.new(response)
    else
      raise Faraday::Error.new(nil, response)
    end
  end
end
