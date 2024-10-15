This example illustrates scheduled query rules log in combination with a metric alert. Multiple scheduled query logs can be added under the scheduled_query_rules_logs key.

## Usage: scheduled_query_rules_log

```hcl
module "alerts" {
  source  = "cloudnationhq/alerts/azure"
  version = "~> 1.0"

  config = {
    metrics_alerts = {
      ma1 = {
        name           = "ma1"
        resource_group = module.rg.groups.demo.name
        scopes         = [module.analytics.workspace.id]
        frequency      = "PT1M"
        window_size    = "PT5M"

        criteria = {
          metric_namespace = "Microsoft.OperationalInsights/workspaces"
          metric_name      = "UsedCapacity"
          aggregation      = "Average"
          operator         = "LessThan"
          threshold        = 10
        }

        action_group = {
          action_group_id = module.mag.groups.demo.id
        }
      }
    }

    scheduled_query_rules_logs = {
      sqrl1 = {
        name           = "sqrl1"
        location       = module.rg.groups.demo.location
        resource_group = module.rg.groups.demo.name
        data_source_id = module.analytics.workspace.id
        enabled        = true
        criteria = {
          metric_name = "Average_% Idle Time"
          dimension = {
            name     = "Computer"
            operator = "Include"
            values   = ["targetVM"]
          }
        }
      }
    }
  }
}
```