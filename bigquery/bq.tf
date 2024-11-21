module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 9.0"

  dataset_id                  = "foo"
  dataset_name                = "foo"
  description                 = "some description"
  project_id                  = var.project_id
  location                    = var.dataset_location
  default_table_expiration_ms = 3600000
  #resource_tags               = { "devops" : "true" }

  tables = [
    {
      table_id = "foo",
      schema   = file("schema.json"),
      time_partitioning = {
        type                     = "DAY",
        field                    = null,
        require_partition_filter = false,
        expiration_ms            = null,
      },
      range_partitioning = null,
      expiration_time    = null,
      clustering         = ["fullVisitorId", "visitId"],
      labels = {
        env      = "dev"
        billable = "true"
        owner    = "joedoe"
      },
    },
    {
      table_id          = "bar",
      schema            = file("schema.json"),
      time_partitioning = null,
      range_partitioning = {
        field = "customer_id",
        range = {
          start    = "1"
          end      = "100",
          interval = "10",
        },
      },
      expiration_time = local.valid_expiration_time, # 2050/01/01
      clustering      = [],
      labels = {
        env      = "devops"
        billable = "true"
        owner    = "joedoe"
      }
    }
  ]
  views = [
    {
      view_id        = "barview"
      use_legacy_sql = false
      query          = <<EOF
    SELECT
    column_a,
    column_b
    FROM
    `project_id.dataset_id.table_id`
    WHERE
    approved_user = SESSION_USER
    EOF
      labels = {
        env      = "devops"
        billable = "true"
        owner    = "joedoe"
      }
    }
  ]

  dataset_labels = {
    env      = "dev"
    billable = "true"
  }
}


