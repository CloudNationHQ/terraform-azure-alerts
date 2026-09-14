moved {
  from = azurerm_monitor_metric_alert.ma
  to   = azurerm_monitor_metric_alert.this
}

moved {
  from = azurerm_monitor_activity_log_alert.ala
  to   = azurerm_monitor_activity_log_alert.this
}

moved {
  from = azurerm_monitor_alert_processing_rule_action_group.aprag
  to   = azurerm_monitor_alert_processing_rule_action_group.this
}

moved {
  from = azurerm_monitor_alert_processing_rule_suppression.aprs
  to   = azurerm_monitor_alert_processing_rule_suppression.this
}

moved {
  from = azurerm_monitor_alert_prometheus_rule_group.aprg
  to   = azurerm_monitor_alert_prometheus_rule_group.this
}

moved {
  from = azurerm_monitor_smart_detector_alert_rule.sdar
  to   = azurerm_monitor_smart_detector_alert_rule.this
}

moved {
  from = azurerm_monitor_scheduled_query_rules_log.sqrl
  to   = azurerm_monitor_scheduled_query_rules_log.this
}
