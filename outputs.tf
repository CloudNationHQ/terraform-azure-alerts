output "activity_log_alert" {
  description = "contains all activity log alert configuration"
  value       = azurerm_monitor_activity_log_alert.ala
}

output "alert_processing_rule_action_group" {
  description = "contains all alert processing rule action group configuration"
  value       = azurerm_monitor_alert_processing_rule_action_group.aprag
}

output "alert_processing_rule_suppression" {
  description = "contains all alert processing rule suppression configuration"
  value       = azurerm_monitor_alert_processing_rule_suppression.aprs
}

output "alert_prometheus_rule_group" {
  description = "contains all alert prometheus rule group configuration"
  value       = azurerm_monitor_alert_prometheus_rule_group.aprg
}

output "metric_alert" {
  description = "contains all metric alert configuration"
  value       = azurerm_monitor_metric_alert.ma
}

output "scheduled_query_rules_log" {
  description = "contains all scheduled query rules log configuration"
  value       = azurerm_monitor_scheduled_query_rules_log.sqrl
}

output "smart_detector_alert_rule" {
  description = "contains all smart detector alert rule configuration"
  value       = azurerm_monitor_smart_detector_alert_rule.sdar
}