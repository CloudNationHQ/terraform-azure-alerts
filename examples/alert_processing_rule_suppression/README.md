This example illustrates one alert processing rule suppression. Multiple alert processing rule suppressions can be added under the alert_processing_rule_suppression key.

## Usage: alert_processing_rule_suppression

```hcl
module "alerts" {
  source  = "cloudnationhq/alerts/azure"
  version = "~> 1.0"

  config = {
    alert_processing_rule_suppressions = {
      aprs1 = {
        name           = "aprs1"
        resource_group = module.rg.groups.demo.name
        scopes         = [module.rg.groups.demo.id]

        condition = {
          target_resource_type = {
            operator = "Equals"
            values   = ["Microsoft.Compute/VirtualMachines"]
          }
          severity = {
            operator = "Equals"
            values   = ["Sev0", "Sev1", "Sev2"]
          }
        }

        schedule = {
          effective_from  = "2022-01-01T01:02:03"
          effective_until = "2022-02-02T01:02:03"
          time_zone       = "Central Europe Standard Time"
          recurrence = {
            daily = {
              start_time = "17:00:00"
              end_time   = "09:00:00"
            }
            weekly = {
              days_of_week = ["Saturday", "Sunday"]
            }
          }
        }
      }
    }
  }
}
```