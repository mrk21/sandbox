require "net/http"
require "uri"
require "json"

require_relative "azure_ad"

module PowerBi
  class ApiClient
    def initialize(token, logger:)
      @token = token
      @logger_io = LoggerIO.new(logger)
    end

    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/reports/get-report-in-group
    def group_report(group_id:, report_id:)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{group_id}/reports/#{report_id}")
      req = Net::HTTP::Get.new(url.path)
      req["Content-Type"] = "application/json"
      req["Authorization"] = "Bearer #{@token.token}"

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.set_debug_output(@logger_io) if ENV["OAUTH_DEBUG"] == "true"
      res = http.request(req)
      raise StandardError, "Invalid Response(#{res.code}): #{res.body}" if res.code != "200"
      body = JSON.parse(res.body)
    end

    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/embed-token/generate-token
    def generate_token(form)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/GenerateToken")
      req = Net::HTTP::Post.new(url.path)
      req["Content-Type"] = "application/json"
      req["Authorization"] = "Bearer #{@token.token}"
      req.body = form.to_json

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.set_debug_output(@logger_io) if ENV["OAUTH_DEBUG"] == "true"
      res = http.request(req)
      raise StandardError, "Invalid Response(#{res.code}): #{res.body}" if res.code != "200"
      body = JSON.parse(res.body)
    end
  end

  class LoggerIO < IO
    def initialize(logger)
      @logger = logger
    end

    def write(str)
      @logger.debug(str.strip)
    end
  end
end
