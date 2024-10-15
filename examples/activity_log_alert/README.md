This example illustrates one activity log alert. Multiple activity log alerts can be added under the activity_log_alerts key.

## Usage: activity_log_alert

```hcl
module "alerts" {
  source  = "cloudnationhq/alerts/azure"
  version = "~> 1.0"

  config = {
    activity_log_alerts = {
      ala1 = {
        name           = "ala1"
        resource_group = module.rg.groups.demo.name
        location       = module.rg.groups.demo.location
        scopes         = [module.rg.groups.demo.id]

        criteria = {
          resource_id    = module.storage.account.id
          operation_name = "Microsoft.Storage/storageAccounts/write"
          category       = "Recommendation"
        }

        action = {
          action_group_id = module.mag.groups.demo.id

          webhook_properties = {
            from = "terraform"
          }
        }
      }
    }
  }
}
```