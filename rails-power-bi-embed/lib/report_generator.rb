class ReportGenerator
  def initialize
    # Get Access Token and make PowerBI REST API client
    @powerbi = PowerBi::auth_and_make_client_from_global_config
  end

  def create_report_from_template_report(template_report_id:)
    workspace_id = ENV["POWER_BI_WORKSPACE_ID"]

    source_report = @powerbi.clone_report_in_group(group_id: workspace_id, report_id: template_report_id, data: { name: "SalesMarketing_source" })
    dest_report = @powerbi.clone_report_in_group(group_id: workspace_id, report_id: template_report_id, data: { name: "SalesMarketing_dest" })
    datasets = DatasetGenerator.new.create_filtered_dataset_from_source_dataset()

    @powerbi.rebind_report_in_group(group_id: workspace_id, report_id: source_report.id, dataset_id: datasets.soruce_dataset.id)
    @powerbi.rebind_report_in_group(group_id: workspace_id, report_id: dest_report.id, dataset_id: datasets.dest_dataset.id)
  end

  def import_report(path:)
    workspace_id = ENV["POWER_BI_WORKSPACE_ID"]
    file = File.open(path, "rb")
    @powerbi.post_import_in_group(group_id: workspace_id, data: file)
  end

  # NOTE: A report used a push-dataset can not export
  def export_report(report_id:)
    workspace_id = ENV["POWER_BI_WORKSPACE_ID"]
    report_file = @powerbi.export_report_in_group(group_id: workspace_id, report_id: report_id)
    Rails.root.join("tmp/report_#{report_id}.pbix").open("wb") do |f|
      f.write(report_file)
    end
  end
end
