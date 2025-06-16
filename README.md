# Azure Monitor Alerts

This terraform module streamlines the setup and management of the Azure Monitor Alerts, providing customizable configurations for different types of alerts.

## Features

Monitor azure resource changes with activity log alerts

Track performance metrics with configurable thresholds and conditions

Schedule Log Analytics queries for proactive monitoring

Deploy prometheus rule groups for kubernetes cluster monitoring

Detect anomalies automatically using smart detector alert rules

Route alerts to action groups with processing rule conditions

Suppress notifications during maintenance windows and planned downtime

Utilization of terratest for robust validation

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9.3)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_monitor_activity_log_alert.ala](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert) (resource)
- [azurerm_monitor_alert_processing_rule_action_group.aprag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_processing_rule_action_group) (resource)
- [azurerm_monitor_alert_processing_rule_suppression.aprs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_processing_rule_suppression) (resource)
- [azurerm_monitor_alert_prometheus_rule_group.aprg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_prometheus_rule_group) (resource)
- [azurerm_monitor_metric_alert.ma](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) (resource)
- [azurerm_monitor_scheduled_query_rules_log.sqrl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_log) (resource)
- [azurerm_monitor_smart_detector_alert_rule.sdar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_smart_detector_alert_rule) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_config"></a> [config](#input\_config)

Description: Contains all alerts configuration

Type:

```hcl
object({
    resource_group_name = optional(string, null)
    location            = optional(string, null)
    tags                = optional(map(string))
    metrics_alerts = optional(map(object({
      name                     = optional(string, null)
      scopes                   = list(string)
      enabled                  = optional(bool, true)
      auto_mitigate            = optional(bool, true)
      description              = optional(string, null)
      frequency                = optional(string, "PT1M")
      severity                 = optional(number, 3)
      target_resource_type     = optional(string, null)
      target_resource_location = optional(string, null)
      window_size              = optional(string, "PT5M")
      action = optional(object({
        action_group_id    = string
        webhook_properties = optional(map(string), null)
      }), null)
      criteria = optional(object({
        metric_namespace       = string
        metric_name            = string
        aggregation            = string
        operator               = string
        threshold              = number
        skip_metric_validation = optional(bool, false)
        dimension = optional(object({
          name     = string
          operator = string
          values   = list(string)
        }), null)
      }), null)
      dynamic_criteria = optional(object({
        metric_namespace         = string
        metric_name              = string
        aggregation              = string
        operator                 = string
        alert_sensitivity        = string
        evaluation_total_count   = optional(number, 4)
        evaluation_failure_count = optional(number, 4)
        ignore_data_before       = optional(string, null)
        skip_metric_validation   = optional(bool, null)
        dimension = optional(object({
          name     = string
          operator = string
          values   = list(string)
        }), null)
      }), null)
      application_insights_web_test_location_availability_criteria = optional(object({
        web_test_id           = string
        component_id          = string
        failed_location_count = number
      }), null)
    })), {})
    activity_log_alerts = optional(map(object({
      name        = optional(string, null)
      scopes      = list(string)
      enabled     = optional(bool, true)
      description = optional(string, null)
      action = optional(object({
        action_group_id    = string
        webhook_properties = optional(map(string), null)
      }), null)
      criteria = optional(object({
        category                = string
        caller                  = optional(string, null)
        operation_name          = optional(string, null)
        resource_provider       = optional(string, null)
        resource_providers      = optional(list(string), null)
        resource_type           = optional(string, null)
        resource_types          = optional(list(string), null)
        resource_group          = optional(string, null)
        resource_groups         = optional(list(string), null)
        resource_id             = optional(string, null)
        resource_ids            = optional(list(string), null)
        level                   = optional(string, null)
        levels                  = optional(list(string), null)
        status                  = optional(string, null)
        statuses                = optional(list(string), null)
        sub_status              = optional(string, null)
        sub_statuses            = optional(list(string), null)
        recommendation_type     = optional(string, null)
        recommendation_category = optional(string, null)
        recommendation_impact   = optional(string, null)
        resource_health = optional(object({
          current  = optional(list(string), null)
          previous = optional(list(string), null)
          reason   = optional(list(string), null)
        }), null)
        service_health = optional(object({
          events    = optional(list(string), null)
          locations = optional(list(string), null)
          services  = optional(list(string), null)
        }), null)
      }), null)
    })), {})
    alert_processing_rule_action_groups = optional(map(object({
      add_action_group_ids = list(string)
      name                 = optional(string, null)
      scopes               = list(string)
      description          = optional(string, null)
      enabled              = optional(bool, true)
      condition = optional(object({
        alert_context = optional(object({
          operator = string
          values   = list(string)
        }), null)
        alert_rule_id = optional(object({
          operator = string
          values   = list(string)
        }), null)
        alert_rule_name = optional(object({
          operator = string
          values   = list(string)
        }), null)
        description = optional(object({
          operator = string
          values   = list(string)
        }), null)
        monitor_condition = optional(object({
          operator = string
          values   = list(string)
        }), null)
        monitor_service = optional(object({
          operator = string
          values   = list(string)
        }), null)
        severity = optional(object({
          operator = string
          values   = list(string)
        }), null)
        signal_type = optional(object({
          operator = string
          values   = list(string)
        }), null)
        target_resource = optional(object({
          operator = string
          values   = list(string)
        }), null)
        target_resource_group = optional(object({
          operator = string
          values   = list(string)
        }), null)
        target_resource_type = optional(object({
          operator = string
          values   = list(string)
        }), null)
      }), null)
      schedule = optional(object({
        effective_from  = optional(string, null)
        effective_until = optional(string, null)
        time_zone       = optional(string, "UTC")
        recurrence = optional(object({
          daily = optional(object({
            start_time = string
            end_time   = string
          }), null)
          weekly = optional(object({
            days_of_week = list(string)
            start_time   = optional(string, null)
            end_time     = optional(string, null)
          }), null)
          monthly = optional(object({
            days_of_month = list(number)
            start_time    = optional(string, null)
            end_time      = optional(string, null)
          }), null)
        }), null)
      }), null)
    })), {})
    alert_processing_rule_suppressions = optional(map(object({
      name        = optional(string, null)
      scopes      = list(string)
      description = optional(string, null)
      enabled     = optional(bool, true)
      condition = optional(object({
        alert_context = optional(object({
          operator = string
          values   = list(string)
        }), null)
        alert_rule_id = optional(object({
          operator = string
          values   = list(string)
        }), null)
        alert_rule_name = optional(object({
          operator = string
          values   = list(string)
        }), null)
        description = optional(object({
          operator = string
          values   = list(string)
        }), null)
        monitor_condition = optional(object({
          operator = string
          values   = list(string)
        }), null)
        monitor_service = optional(object({
          operator = string
          values   = list(string)
        }), null)
        severity = optional(object({
          operator = string
          values   = list(string)
        }), null)
        signal_type = optional(object({
          operator = string
          values   = list(string)
        }), null)
        target_resource = optional(object({
          operator = string
          values   = list(string)
        }), null)
        target_resource_group = optional(object({
          operator = string
          values   = list(string)
        }), null)
        target_resource_type = optional(object({
          operator = string
          values   = list(string)
        }), null)
      }), null)
      schedule = optional(object({
        effective_from  = optional(string, null)
        effective_until = optional(string, null)
        time_zone       = optional(string, "UTC")
        recurrence = optional(object({
          daily = optional(object({
            start_time = string
            end_time   = string
          }), null)
          weekly = optional(object({
            days_of_week = list(string)
            start_time   = optional(string, null)
            end_time     = optional(string, null)
          }), null)
          monthly = optional(object({
            days_of_month = list(number)
            start_time    = optional(string, null)
            end_time      = optional(string, null)
          }), null)
        }), null)
      }), null)
    })), {})
    alert_prometheus_rule_groups = optional(map(object({
      name               = optional(string, null)
      location           = optional(string, null)
      scopes             = list(string)
      cluster_name       = optional(string, null)
      description        = optional(string, null)
      rule_group_enabled = optional(bool, null)
      interval           = optional(string, null)
      rules = optional(map(object({
        alert       = optional(string, null)
        annotations = optional(map(string), null)
        enabled     = optional(bool, true)
        expression  = string
        for         = optional(string, null)
        labels      = optional(map(string), null)
        record      = optional(string, null)
        severity    = optional(number, null)
        action = optional(object({
          action_group_id   = string
          action_properties = optional(map(string), null)
        }), null)
        alert_resolution = optional(object({
          auto_resolved   = bool
          time_to_resolve = string
        }), null)
      })), {})
    })), {})
    smart_detector_alert_rules = optional(map(object({
      name                = optional(string, null)
      detector_type       = string
      scope_resource_ids  = list(string)
      severity            = string
      frequency           = string
      description         = optional(string, null)
      enabled             = optional(bool, true)
      throttling_duration = optional(string, null)
      action_group = optional(object({
        ids             = list(string)
        email_subject   = optional(string, null)
        webhook_payload = optional(string, null)
      }), null)
    })), {})
    scheduled_query_rules_logs = optional(map(object({
      name                    = optional(string, null)
      location                = optional(string, null)
      data_source_id          = string
      authorized_resource_ids = optional(list(string), null)
      description             = optional(string, null)
      enabled                 = optional(bool, true)
      criteria = optional(object({
        metric_name = string
        dimension = optional(object({
          name     = string
          operator = string
          values   = list(string)
        }), null)
      }), null)
    })), {})
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: Default Azure region

Type: `string`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Default resource group name

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Default tags for all resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_activity_log_alert"></a> [activity\_log\_alert](#output\_activity\_log\_alert)

Description: contains all activity log alert configuration

### <a name="output_alert_processing_rule_action_group"></a> [alert\_processing\_rule\_action\_group](#output\_alert\_processing\_rule\_action\_group)

Description: contains all alert processing rule action group configuration

### <a name="output_alert_processing_rule_suppression"></a> [alert\_processing\_rule\_suppression](#output\_alert\_processing\_rule\_suppression)

Description: contains all alert processing rule suppression configuration

### <a name="output_alert_prometheus_rule_group"></a> [alert\_prometheus\_rule\_group](#output\_alert\_prometheus\_rule\_group)

Description: contains all alert prometheus rule group configuration

### <a name="output_metric_alert"></a> [metric\_alert](#output\_metric\_alert)

Description: contains all metric alert configuration

### <a name="output_scheduled_query_rules_log"></a> [scheduled\_query\_rules\_log](#output\_scheduled\_query\_rules\_log)

Description: contains all scheduled query rules log configuration

### <a name="output_smart_detector_alert_rule"></a> [smart\_detector\_alert\_rule](#output\_smart\_detector\_alert\_rule)

Description: contains all smart detector alert rule configuration
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-alerts/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-alerts" />
</a>

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-alerts/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)
