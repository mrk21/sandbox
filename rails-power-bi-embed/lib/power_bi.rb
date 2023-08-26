require 'net/http'
require 'uri'
require 'json'

require_relative 'azure_ad'

module PowerBi
  class ApiClient
    def initialize(token)
      @token = token
    end

    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/reports/get-report-in-group
    def group_report(group_id:, report_id:)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{group_id}/reports/#{report_id}")
      req = Net::HTTP::Get.new(url.path)
      req['Content-Type'] = "application/json"
      req['Authorization'] = "Bearer #{@token.token}"

      result = Net::HTTP.start(url.host, url.port, use_ssl: true) {|http|
        res = http.request(req)
        raise StandardError, "Invalid Response(#{res.code}): #{res.body}" if res.code != '200'
        body = JSON.parse(res.body)
        body
      }
    end

    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/embed-token/generate-token
    def generate_token(form)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/GenerateToken")
      req = Net::HTTP::Post.new(url.path)
      req['Content-Type'] = "application/json"
      req['Authorization'] = "Bearer #{@token.token}"
      req.body = form.to_json

      result = Net::HTTP.start(url.host, url.port, use_ssl: true) {|http|
        res = http.request(req)
        raise StandardError, "Invalid Response(#{res.code}): #{res.body}" if res.code != '200'
        body = JSON.parse(res.body)
        body
      }
    end
  end
end
