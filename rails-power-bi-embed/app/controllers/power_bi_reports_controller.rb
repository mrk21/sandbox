require "azure_ad"
require "power_bi"

class PowerBiReportsController < ApplicationController
  def show
  end

  def embed_data
    # Get Access Token and make PowerBI REST API client
    powerbi = PowerBi::auth_and_make_client_from_global_config

    # Params
    report_id = ENV["POWER_BI_REPORT_ID"]
    workspace_id = ENV["POWER_BI_WORKSPACE_ID"]

    # Get PowerBI Report
    report = powerbi.get_report_in_group(group_id: workspace_id, report_id: report_id)

    # Generate Power BI Embed Token
    form = {
      reports: [{
        id: report.id,
      }],
      datasets: [{
        id: report.datasetId,
      }],
      targetWorkspaces: [{
        id: workspace_id,
      }],
    }
    embed_token = powerbi.generate_token(form)

    # Response
    res = {
      accessToken: embed_token.token,
      expiry: embed_token.expiration,
      embedUrl: [
        {
          reportId: report.id,
          reportName: report.name,
          embedUrl: report.embedUrl,
        },
      ],
    }
    render json: res
  end
end
