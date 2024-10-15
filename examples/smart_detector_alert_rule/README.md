This example illustrates one smart detector alert rule. Multiple smart detector alert rules can be added under the smart_detector_alert_rules key.

## Usage: smart_detector_alert_rule

```hcl
module "alerts" {
  source  = "cloudnationhq/alerts/azure"
  version = "~> 1.0"

  config = {
    smart_detector_alert_rules = {
      sdar1 = {
        name               = "sdar1"
        resource_group     = module.rg.groups.demo.name
        severity           = "Sev0"
        scope_resource_ids = [module.appi.config.id]
        frequency          = "PT1M"
        detector_type      = "FailureAnomaliesDetector"

        action_group = {
          ids = [module.mag.groups.demo.id]
        }
      }
    }
  }
}

```