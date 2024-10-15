This example illustrates one metric alert. Multiple metric alerts can be added under the metrics_alerts key.

## Usage: metric_alert

```hcl
module "alerts" {
  source  = "cloudnationhq/alerts/azure"
  version = "~> 1.0"

  config = {
    metrics_alerts = {
      ma1 = {
        name           = "ma1"
        resource_group = module.rg.groups.demo.name
        scopes         = [module.storage.account.id]
        criteria = {
          metric_namespace = "Microsoft.Storage/storageAccounts"
          metric_name      = "Transactions"
          aggregation      = "Total"
          operator         = "GreaterThan"
          threshold        = 50

          dimension = {
            name     = "ApiName"
            operator = "Include"
            values   = ["*"]
          }
        }

        action_group = {
          action_group_id = module.mag.groups.demo.id
        }
      }
    }
  }
}
```