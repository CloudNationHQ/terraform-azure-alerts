# Azure Monitor Alerts

This terraform module streamlines the setup and management of the Azure Monitor Alerts, providing customizable configurations for different types of alerts.

## Features

- Create an Activity Log Alert
- Create an Alert Processing Rule Action Group
- Create an Alert Processing Rule Suppression
- Create an Alert Prometheus Rule Group
- Create a Metric Alert
- Create a Scheduled Query Rules Log
- Create a Smart Detector Alert Rule

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_activity_log_alert.ala](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert) | resource |
| [azurerm_monitor_alert_processing_rule_action_group.aprag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_processing_rule_action_group) | resource |
| [azurerm_monitor_alert_processing_rule_suppression.aprs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_processing_rule_suppression) | resource |
| [azurerm_monitor_alert_prometheus_rule_group.aprg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_prometheus_rule_group) | resource |
| [azurerm_monitor_metric_alert.ma](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_scheduled_query_rules_log.sqrl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_log) | resource |
| [azurerm_monitor_smart_detector_alert_rule.sdar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_smart_detector_alert_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config"></a> [config](#input\_config) | alert related configuration | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | default azure region to be used. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | default resource group to be used. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to be added to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_activity_log_alert"></a> [activity\_log\_alert](#output\_activity\_log\_alert) | contains all activity log alert configuration |
| <a name="output_alert_processing_rule_action_group"></a> [alert\_processing\_rule\_action\_group](#output\_alert\_processing\_rule\_action\_group) | contains all alert processing rule action group configuration |
| <a name="output_alert_processing_rule_suppression"></a> [alert\_processing\_rule\_suppression](#output\_alert\_processing\_rule\_suppression) | contains all alert processing rule suppression configuration |
| <a name="output_alert_prometheus_rule_group"></a> [alert\_prometheus\_rule\_group](#output\_alert\_prometheus\_rule\_group) | contains all alert prometheus rule group configuration |
| <a name="output_metric_alert"></a> [metric\_alert](#output\_metric\_alert) | contains all metric alert configuration |
| <a name="output_scheduled_query_rules_log"></a> [scheduled\_query\_rules\_log](#output\_scheduled\_query\_rules\_log) | contains all scheduled query rules log configuration |
| <a name="output_smart_detector_alert_rule"></a> [smart\_detector\_alert\_rule](#output\_smart\_detector\_alert\_rule) | contains all smart detector alert rule configuration |
<!-- END_TF_DOCS -->

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-alerts/graphs/contributors).

## Contributing

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-alerts/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)
