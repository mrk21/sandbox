class DatasetGenerator
  def initialize
    # Get Access Token and make PowerBI REST API client
    @powerbi = PowerBi::auth_and_make_client_from_global_config
  end

  def create_filtered_dataset_from_source_dataset
    soruce_dataset = create_dataset(name: "SalesMarketing_from")
    push_dataset(dataset_id: soruce_dataset.id)

    dest_dataset = create_dataset(name: "SalesMarketing_to")
    dest_rows = fetch_dataset_rows(dataset_id: soruce_dataset.id, query: "EVALUATE FILTER(Product, Product[ProductID] > 1)")
    dest_rows = dest_rows.results[0].tables[0].rows.map(&method(:row_to_hash))
    push_dataset(dataset_id: dest_dataset.id, data: { rows: dest_rows })
  end

  def create_dataset(name: "SalesMarketing")
    # Params
    workspace_id = ENV["POWER_BI_WORKSPACE_ID"]

    # Push dataset
    data = {
      "name": name,
      "defaultMode": "Push",
      "tables": [
        {
          "name": "Product",
          "columns": [
            {
              "name": "ProductID",
              "dataType": "Int64",
            },
            {
              "name": "Name",
              "dataType": "string",
            },
            {
              "name": "Category",
              "dataType": "string",
            },
            {
              "name": "IsCompete",
              "dataType": "bool",
            },
            {
              "name": "ManufacturedOn",
              "dataType": "DateTime",
            },
            {
              "name": "Sales",
              "dataType": "Int64",
              "formatString": "Currency",
            },
          ],
        },
      ],
    }
    @powerbi.post_dataset_in_group(group_id: workspace_id, data: data)
  end

  def push_dataset(dataset_id:, data: nil)
    # Params
    workspace_id = ENV["POWER_BI_WORKSPACE_ID"]

    # Push rows
    if data.nil?
      data = {
        "rows": [
          {
            "ProductID": 1,
            "Name": "Adjustable Race",
            "Category": "Components",
            "IsCompete": true,
            "ManufacturedOn": "07/30/2014",
          },
          {
            "ProductID": 2,
            "Name": "LL Crankarm",
            "Category": "Components",
            "IsCompete": true,
            "ManufacturedOn": "07/30/2014",
          },
          {
            "ProductID": 3,
            "Name": "HL Mountain Frame - Silver",
            "Category": "Bikes",
            "IsCompete": true,
            "ManufacturedOn": "07/30/2014",
          },
        ],
      }
    end
    @powerbi.post_rows_in_group(group_id: workspace_id, dataset_id: dataset_id, table_name: "Product", data: data)
  end

  # ```json
  # {
  #   "results": [
  #     {
  #       "tables": [
  #         {
  #           "rows": [
  #             {
  #               "Product[ProductID]": 2,
  #               "Product[Name]": "LL Crankarm",
  #               "Product[Category]": "Components",
  #               "Product[IsCompete]": true,
  #               "Product[ManufacturedOn]": "2014-07-30T00:00:00",
  #               "Product[Sales]": null
  #             },
  #             {
  #               "Product[ProductID]": 3,
  #               "Product[Name]": "HL Mountain Frame - Silver",
  #               "Product[Category]": "Bikes",
  #               "Product[IsCompete]": true,
  #               "Product[ManufacturedOn]": "2014-07-30T00:00:00",
  #               "Product[Sales]": null
  #             }
  #           ]
  #         }
  #       ]
  #     }
  #   ]
  # }
  # ```
  def fetch_dataset_rows(dataset_id:, query: "EVALUATE VALUES(Product)")
    # Params
    workspace_id = ENV["POWER_BI_WORKSPACE_ID"]
    data = {
      "queries": [
        {
          "query": query,
        },
      ],
      "serializerSettings": {
        "includeNulls": true,
      },
    }
    @powerbi.execute_queries_in_group(group_id: workspace_id, dataset_id: dataset_id, data: data)
  end

  def rebind_dataset(dataset_id:, report_id:)
    # Params
    workspace_id = ENV["POWER_BI_WORKSPACE_ID"]

    # Rebind Power BI Report
    @powerbi.rebind_report_in_group(group_id: workspace_id, report_id: report_id, dataset_id: dataset_id)
  end

  # Transform row to hash
  #
  # `{ "Table[Column]" => value }` => `{ "Column" => value }`
  #
  # ```ruby
  # {
  #   "Product[ProductID]" => 2,
  #   "Product[Name]" => "LL Crankarm",
  #   "Product[Category]" => "Components",
  #   "Product[IsCompete]" => true,
  #   "Product[ManufacturedOn]" => "2014-07-30T00:00:00",
  #   "Product[Sales]" => nil
  # }
  # ```
  def row_to_hash(row)
    row.to_h.transform_keys { |key| key.to_s.gsub(/\w+\[(\w+)\]/, '\1').to_sym }
  end
end
