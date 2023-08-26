require 'azure_ad'
require 'power_bi'

class PowerBiReportsController < ApplicationController
  def show
  end

  def embed_data
    config = AzureAd::AppConfig.new(
      client_id: ENV['AZURE_CLIENT_ID'],
      client_secret: ENV['AZURE_CLIENT_SECRET'],
      authority: File.join("https://login.microsoftonline.com", ENV['AZURE_TENANT_ID']),
      scopes: ['https://analysis.windows.net/powerbi/api/.default'],
    )
    workspace_id = ENV['POWER_BI_WORKSPACE_ID']
    report_id = ENV['POWER_BI_REPORT_ID']

    azure_ad_app = AzureAd::AppClient.new(config)
    token = azure_ad_app.acquire_token_by_client_credential

    powerbi = PowerBi::ApiClient.new(token)
    report = powerbi.group_report(group_id: workspace_id, report_id: report_id)

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
