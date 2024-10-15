This example illustrates one alert prometheus rule group. Multiple alert prometheus rule groups can be added under the alert_prometheus_rule_groups key, every alert prometheus rule group can contain multiple rules.

## Usage: alert_prometheus_rule_group

```hcl
module "alerts" {
  source  = "cloudnationhq/alerts/azure"
  version = "~> 1.0"

  config = {
    alert_prometheus_rule_groups = {
      aprg1 = {
        name               = "aprg1"
        location           = module.rg.groups.demo.location
        resource_group     = module.rg.groups.demo.name
        cluster_name       = module.aks.cluster.name
        rule_group_enabled = false
        interval           = "PT1M"
        scopes             = [module.mw.workspace.id]
        rules = {
          rule1 = {
            enabled    = false
            expression = <<EOF
histogram_quantile(0.99, sum(rate(jobs_duration_seconds_bucket{service="billing-processing"}[5m])) by (job_type))
EOF
            record     = "job_type:billing_jobs_duration_seconds:99p5m"
            labels = {
              team = "dev"
            }
          }
          rule2 = {
            alert      = "Billing_Processing_Very_Slow"
            enabled    = true
            expression = <<EOF
histogram_quantile(0.99, sum(rate(jobs_duration_seconds_bucket{service="billing-processing"}[5m])) by (job_type))
EOF
            for        = "PT5M"
            severity   = 2

            action = {
              action_group_id = module.mag.groups.demo.id
            }

            alert_resolution = {
              auto_resolved   = true
              time_to_resolve = "PT10M"
            }

            annotations = {
              annotationName = "annotationValue"
            }

            labels = {
              team = "dev"
            }
          }
        }
      }
    }
  }
}
```