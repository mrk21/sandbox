require "net/http"
require "uri"
require "json"

require_relative "azure_ad"

module PowerBi
  def self.auth_and_make_client_from_global_config
    # Get Access Token
    config = AzureAd::AppConfig.new(
      client_id: ENV["AZURE_CLIENT_ID"],
      client_secret: ENV["AZURE_CLIENT_SECRET"],
      authority: File.join("https://login.microsoftonline.com", ENV["AZURE_TENANT_ID"]),
    )
    azure_ad_app = AzureAd::AppClient.new(config, logger: Rails.logger)
    scopes = ["https://analysis.windows.net/powerbi/api/.default"]
    token = case ENV["AZURE_AUTH_MODE"]
      when "service_principal"
        azure_ad_app.acquire_token_by_client_credential(
          scopes: scopes,
        )
      when "master_user"
        azure_ad_app.acquire_token_by_username_password(
          scopes: scopes,
          username: ENV["AZURE_MASTER_USERNAME"],
          password: ENV["AZURE_MASTER_PASSWORD"],
        )
      else
        raise ArgumentError, "Invalid AZURE_AUTH_TYPE: #{ENV["AZURE_AUTH_TYPE"]}"
      end

    # Create PowerBI REST API client
    powerbi = PowerBi::ApiClient.new(token, logger: Rails.logger)
  end

  class ApiClient
    def initialize(token, logger:)
      @token = token
      @logger_io = LoggerIO.new(logger)
    end

    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/reports/get-report-in-group
    def get_report_in_group(group_id:, report_id:)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{group_id}/reports/#{report_id}")
      self.request(method: :get, url: url)
    end

    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/reports/clone-report-in-group
    def clone_report_in_group(group_id:, report_id:, data:)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{group_id}/reports/#{report_id}/Clone")
      self.request(method: :post, url: url, data: data)
    end

    # @option data [Hash | File]
    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/imports/post-import-in-group
    def post_import_in_group(group_id:, data:)
      case data
      when File
        dataset_display_name = Pathname.new(data.path).basename
        url = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{group_id}/imports?datasetDisplayName=#{dataset_display_name}")
        data = [["file", data]]
        self.request(method: :post, url: url, data: data, content_type: "multipart/form-data")
      else
        dataset_display_name = data[:filePath]
        url = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{group_id}/imports?datasetDisplayName=#{dataset_display_name}")
        self.request(method: :post, url: url, data: data)
      end
    end

    # NOTE: A report used a push-dataset can not export
    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/reports/export-report-in-group
    def export_report_in_group(group_id:, report_id:)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{group_id}/reports/#{report_id}/Export")
      self.request(method: :get, url: url)
    end

    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/reports/rebind-report-in-group
    def rebind_report_in_group(group_id:, report_id:, dataset_id:)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{group_id}/reports/#{report_id}/Rebind")
      data = ({ datasetId: dataset_id })
      self.request(method: :post, url: url, data: data)
    end

    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/embed-token/generate-token
    def generate_token(form)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/GenerateToken")
      self.request(method: :post, url: url, data: form)
    end

    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/push-datasets/datasets-post-dataset-in-group
    # @see https://learn.microsoft.com/en-us/power-bi/developer/embedded/push-datasets-limitations
    # @see https://learn.microsoft.com/en-us/power-bi/connect-data/service-real-time-streaming
    # @see https://speakerdeck.com/hanaseleb/putusiyudetasetutowoshi-sitemiyou
    def post_dataset_in_group(group_id:, data:)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{group_id}/datasets")
      self.request(method: :post, url: url, data: data)
    end

    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/push-datasets/datasets-post-rows-in-group
    # @see https://speakerdeck.com/hanaseleb/putusiyudetasetutowoshi-sitemiyou
    def post_rows_in_group(group_id:, dataset_id:, table_name:, data:)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{group_id}/datasets/#{dataset_id}/tables/#{table_name}/rows")
      self.request(method: :post, url: url, data: data)
    end

    # @see https://learn.microsoft.com/en-us/rest/api/power-bi/datasets/execute-queries-in-group
    def execute_queries_in_group(group_id:, dataset_id:, data:)
      url = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{group_id}/datasets/#{dataset_id}/executeQueries")
      self.request(method: :post, url: url, data: data)
    end

    private

    # @option method [:get | :post | :put | :delete]
    # @option url [URI::HTTPS]
    # @option data [Hash | Array | NilClass]
    # @option content_type [String | NilClass]
    # @return [Hash | HTTP::Response::Body]
    def request(method:, url:, data: nil, content_type: "application/json")
      method_class = Net::HTTP.const_get(method.to_s.capitalize)
      req = method_class.new(url.request_uri)
      req["Authorization"] = "Bearer #{@token.token}"

      case content_type
      when "application/json"
        req["Content-Type"] = "application/json"
        req.body = data.to_json if data.present?
      when "multipart/form-data"
        req.set_form(data, "multipart/form-data")
      end

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.set_debug_output(@logger_io) if ENV["OAUTH_DEBUG"] == "true"
      res = http.request(req)

      case res.code
      when "200", "201", "202"
        content_type = res["Content-Type"].to_s.split(";").first
        case content_type
        when "application/json"
          return JSON.parse(res.body, object_class: OpenStruct)
        when "application/zip", "application/octet-stream"
          return res.body
        else
          return res.body
        end
      else
        raise StandardError, "Invalid Response(#{res.code}): #{res.body}"
      end
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
