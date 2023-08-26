require 'azure_ad'
require 'power_bi'

class PowerBiReportsController < ApplicationController
  def show
  end

  def embed_data
    # Get Access Token
    config = AzureAd::AppConfig.new(
      client_id: ENV['AZURE_CLIENT_ID'],
      client_secret: ENV['AZURE_CLIENT_SECRET'],
      authority: File.join("https://login.microsoftonline.com", ENV['AZURE_TENANT_ID']),
    )
    azure_ad_app = AzureAd::AppClient.new(config, logger: Rails.logger)
    scopes = ['https://analysis.windows.net/powerbi/api/.default']
    token = case ENV['AZURE_AUTH_MODE']
    when 'service_principal' then
      azure_ad_app.acquire_token_by_client_credential(
        scopes: scopes,
      )
    when 'master_user' then
      azure_ad_app.acquire_token_by_username_password(
        scopes: scopes,
        username: ENV['AZURE_MASTER_USERNAME'],
        password: ENV['AZURE_MASTER_PASSWORD'],
      )
    else
      raise ArgumentError, "Invalid AZURE_AUTH_TYPE: #{ENV['AZURE_AUTH_TYPE']}"
    end

    # Get PowerBI Report
    powerbi = PowerBi::ApiClient.new(token, logger: Rails.logger)
    workspace_id = ENV['POWER_BI_WORKSPACE_ID']
    report_id = ENV['POWER_BI_REPORT_ID']
    report = powerbi.group_report(group_id: workspace_id, report_id: report_id)

    # Generate Power BI Embed Token
    form = {
      reports: [{
          id: report['id']
      }],
      datasets: [{
        id: report['datasetId']
      }],
      targetWorkspaces: [{
        id: workspace_id
      }],
    };
    embed_token = powerbi.generate_token(form)

    # Response
    res = {
      accessToken: embed_token['token'],
      expiry: embed_token['expiration'],
      embedUrl: [
        {
          reportId: report['id'],
          reportName: report['name'],
          embedUrl: report['embedUrl'],
        },
      ],
    }
    render json: res
  end
end
