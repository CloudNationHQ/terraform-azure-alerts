# metric alerts
resource "azurerm_monitor_metric_alert" "this" {
  for_each = var.alerts.metrics_alerts

  resource_group_name = coalesce(
    var.alerts.resource_group_name, var.resource_group_name
  )

  name = coalesce(
    each.value.name, each.key
  )

  scopes                   = each.value.scopes
  enabled                  = each.value.enabled
  auto_mitigate            = each.value.auto_mitigate
  description              = each.value.description
  frequency                = each.value.frequency
  severity                 = each.value.severity
  target_resource_type     = each.value.target_resource_type
  target_resource_location = each.value.target_resource_location
  window_size              = each.value.window_size

  tags = coalesce(
    var.alerts.tags, var.tags
  )

  dynamic "action" {
    for_each = each.value.actions

    content {
      action_group_id    = action.value.action_group_id
      webhook_properties = action.value.webhook_properties
    }
  }

  dynamic "criteria" {
    for_each = each.value.criteria

    content {
      metric_namespace       = criteria.value.metric_namespace
      metric_name            = criteria.value.metric_name
      aggregation            = criteria.value.aggregation
      operator               = criteria.value.operator
      threshold              = criteria.value.threshold
      skip_metric_validation = criteria.value.skip_metric_validation

      dynamic "dimension" {
        for_each = criteria.value.dimensions

        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }

  dynamic "dynamic_criteria" {
    for_each = each.value.dynamic_criteria != null ? { "this" = each.value.dynamic_criteria } : {}

    content {
      metric_namespace         = dynamic_criteria.value.metric_namespace
      metric_name              = dynamic_criteria.value.metric_name
      aggregation              = dynamic_criteria.value.aggregation
      operator                 = dynamic_criteria.value.operator
      alert_sensitivity        = dynamic_criteria.value.alert_sensitivity
      evaluation_total_count   = dynamic_criteria.value.evaluation_total_count
      evaluation_failure_count = dynamic_criteria.value.evaluation_failure_count
      ignore_data_before       = dynamic_criteria.value.ignore_data_before
      skip_metric_validation   = dynamic_criteria.value.skip_metric_validation

      dynamic "dimension" {
        for_each = dynamic_criteria.value.dimensions

        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }

  dynamic "application_insights_web_test_location_availability_criteria" {
    for_each = each.value.application_insights_web_test_location_availability_criteria != null ? { "this" = each.value.application_insights_web_test_location_availability_criteria } : {}

    content {
      web_test_id           = application_insights_web_test_location_availability_criteria.value.web_test_id
      component_id          = application_insights_web_test_location_availability_criteria.value.component_id
      failed_location_count = application_insights_web_test_location_availability_criteria.value.failed_location_count
    }
  }
}

# activity log alerts
resource "azurerm_monitor_activity_log_alert" "this" {
  for_each = var.alerts.activity_log_alerts

  resource_group_name = coalesce(
    var.alerts.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.alerts.location, var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  scopes      = each.value.scopes
  enabled     = each.value.enabled
  description = each.value.description

  tags = coalesce(
    var.alerts.tags, var.tags
  )

  dynamic "action" {
    for_each = each.value.actions

    content {
      action_group_id    = action.value.action_group_id
      webhook_properties = action.value.webhook_properties
    }
  }

  dynamic "criteria" {
    for_each = each.value.criteria != null ? { "this" = each.value.criteria } : {}

    content {
      category                = criteria.value.category
      caller                  = criteria.value.caller
      operation_name          = criteria.value.operation_name
      resource_provider       = criteria.value.resource_provider
      resource_providers      = criteria.value.resource_providers
      resource_type           = criteria.value.resource_type
      resource_types          = criteria.value.resource_types
      resource_group          = criteria.value.resource_group
      resource_groups         = criteria.value.resource_groups
      resource_id             = criteria.value.resource_id
      resource_ids            = criteria.value.resource_ids
      level                   = criteria.value.level
      levels                  = criteria.value.levels
      status                  = criteria.value.status
      statuses                = criteria.value.statuses
      sub_status              = criteria.value.sub_status
      sub_statuses            = criteria.value.sub_statuses
      recommendation_type     = criteria.value.recommendation_type
      recommendation_category = criteria.value.recommendation_category
      recommendation_impact   = criteria.value.recommendation_impact

      dynamic "resource_health" {
        for_each = criteria.value.resource_health != null ? { "this" = criteria.value.resource_health } : {}

        content {
          current  = resource_health.value.current
          previous = resource_health.value.previous
          reason   = resource_health.value.reason
        }
      }

      dynamic "service_health" {
        for_each = criteria.value.service_health != null ? { "this" = criteria.value.service_health } : {}

        content {
          events    = service_health.value.events
          locations = service_health.value.locations
          services  = service_health.value.services
        }
      }
    }
  }
}

# process action groups alerts
resource "azurerm_monitor_alert_processing_rule_action_group" "this" {
  for_each = var.alerts.alert_processing_rule_action_groups

  resource_group_name = coalesce(
    var.alerts.resource_group_name, var.resource_group_name
  )

  name = coalesce(
    each.value.name, each.key
  )

  add_action_group_ids = each.value.add_action_group_ids
  scopes               = each.value.scopes
  description          = each.value.description
  enabled              = each.value.enabled

  tags = coalesce(
    var.alerts.tags, var.tags
  )

  dynamic "condition" {
    for_each = each.value.condition != null ? { "this" = each.value.condition } : {}

    content {
      dynamic "alert_context" {
        for_each = condition.value.alert_context != null ? { "this" = condition.value.alert_context } : {}

        content {
          operator = alert_context.value.operator
          values   = alert_context.value.values
        }
      }

      dynamic "alert_rule_id" {
        for_each = condition.value.alert_rule_id != null ? { "this" = condition.value.alert_rule_id } : {}

        content {
          operator = alert_rule_id.value.operator
          values   = alert_rule_id.value.values
        }
      }

      dynamic "alert_rule_name" {
        for_each = condition.value.alert_rule_name != null ? { "this" = condition.value.alert_rule_name } : {}

        content {
          operator = alert_rule_name.value.operator
          values   = alert_rule_name.value.values
        }
      }

      dynamic "description" {
        for_each = condition.value.description != null ? { "this" = condition.value.description } : {}

        content {
          operator = description.value.operator
          values   = description.value.values
        }
      }

      dynamic "monitor_condition" {
        for_each = condition.value.monitor_condition != null ? { "this" = condition.value.monitor_condition } : {}

        content {
          operator = monitor_condition.value.operator
          values   = monitor_condition.value.values
        }
      }

      dynamic "monitor_service" {
        for_each = condition.value.monitor_service != null ? { "this" = condition.value.monitor_service } : {}

        content {
          operator = monitor_service.value.operator
          values   = monitor_service.value.values
        }
      }

      dynamic "severity" {
        for_each = condition.value.severity != null ? { "this" = condition.value.severity } : {}

        content {
          operator = severity.value.operator
          values   = severity.value.values
        }
      }

      dynamic "signal_type" {
        for_each = condition.value.signal_type != null ? { "this" = condition.value.signal_type } : {}

        content {
          operator = signal_type.value.operator
          values   = signal_type.value.values
        }
      }

      dynamic "target_resource" {
        for_each = condition.value.target_resource != null ? { "this" = condition.value.target_resource } : {}

        content {
          operator = target_resource.value.operator
          values   = target_resource.value.values
        }
      }

      dynamic "target_resource_group" {
        for_each = condition.value.target_resource_group != null ? { "this" = condition.value.target_resource_group } : {}

        content {
          operator = target_resource_group.value.operator
          values   = target_resource_group.value.values
        }
      }

      dynamic "target_resource_type" {
        for_each = condition.value.target_resource_type != null ? { "this" = condition.value.target_resource_type } : {}

        content {
          operator = target_resource_type.value.operator
          values   = target_resource_type.value.values
        }
      }
    }
  }

  dynamic "schedule" {
    for_each = each.value.schedule != null ? { "this" = each.value.schedule } : {}

    content {
      effective_from  = schedule.value.effective_from
      effective_until = schedule.value.effective_until
      time_zone       = schedule.value.time_zone

      dynamic "recurrence" {
        for_each = schedule.value.recurrence != null ? { "this" = schedule.value.recurrence } : {}

        content {
          dynamic "daily" {
            for_each = recurrence.value.dailies

            content {
              start_time = daily.value.start_time
              end_time   = daily.value.end_time
            }
          }

          dynamic "weekly" {
            for_each = recurrence.value.weeklies

            content {
              days_of_week = weekly.value.days_of_week
              start_time   = weekly.value.start_time
              end_time     = weekly.value.end_time
            }
          }

          dynamic "monthly" {
            for_each = recurrence.value.monthlies

            content {
              days_of_month = monthly.value.days_of_month
              start_time    = monthly.value.start_time
              end_time      = monthly.value.end_time
            }
          }
        }
      }
    }
  }
}

# process suppression rules
resource "azurerm_monitor_alert_processing_rule_suppression" "this" {
  for_each = var.alerts.alert_processing_rule_suppressions

  resource_group_name = coalesce(
    var.alerts.resource_group_name, var.resource_group_name
  )

  name = coalesce(
    each.value.name, each.key
  )

  scopes      = each.value.scopes
  description = each.value.description
  enabled     = each.value.enabled

  tags = coalesce(
    var.alerts.tags, var.tags
  )

  dynamic "condition" {
    for_each = each.value.condition != null ? { "this" = each.value.condition } : {}

    content {
      dynamic "alert_context" {
        for_each = condition.value.alert_context != null ? { "this" = condition.value.alert_context } : {}

        content {
          operator = alert_context.value.operator
          values   = alert_context.value.values
        }
      }

      dynamic "alert_rule_id" {
        for_each = condition.value.alert_rule_id != null ? { "this" = condition.value.alert_rule_id } : {}

        content {
          operator = alert_rule_id.value.operator
          values   = alert_rule_id.value.values
        }
      }

      dynamic "alert_rule_name" {
        for_each = condition.value.alert_rule_name != null ? { "this" = condition.value.alert_rule_name } : {}

        content {
          operator = alert_rule_name.value.operator
          values   = alert_rule_name.value.values
        }
      }

      dynamic "description" {
        for_each = condition.value.description != null ? { "this" = condition.value.description } : {}

        content {
          operator = description.value.operator
          values   = description.value.values
        }
      }

      dynamic "monitor_condition" {
        for_each = condition.value.monitor_condition != null ? { "this" = condition.value.monitor_condition } : {}

        content {
          operator = monitor_condition.value.operator
          values   = monitor_condition.value.values
        }
      }

      dynamic "monitor_service" {
        for_each = condition.value.monitor_service != null ? { "this" = condition.value.monitor_service } : {}

        content {
          operator = monitor_service.value.operator
          values   = monitor_service.value.values
        }
      }

      dynamic "severity" {
        for_each = condition.value.severity != null ? { "this" = condition.value.severity } : {}

        content {
          operator = severity.value.operator
          values   = severity.value.values
        }
      }

      dynamic "signal_type" {
        for_each = condition.value.signal_type != null ? { "this" = condition.value.signal_type } : {}

        content {
          operator = signal_type.value.operator
          values   = signal_type.value.values
        }
      }

      dynamic "target_resource" {
        for_each = condition.value.target_resource != null ? { "this" = condition.value.target_resource } : {}

        content {
          operator = target_resource.value.operator
          values   = target_resource.value.values
        }
      }

      dynamic "target_resource_group" {
        for_each = condition.value.target_resource_group != null ? { "this" = condition.value.target_resource_group } : {}

        content {
          operator = target_resource_group.value.operator
          values   = target_resource_group.value.values
        }
      }

      dynamic "target_resource_type" {
        for_each = condition.value.target_resource_type != null ? { "this" = condition.value.target_resource_type } : {}

        content {
          operator = target_resource_type.value.operator
          values   = target_resource_type.value.values
        }
      }
    }
  }

  dynamic "schedule" {
    for_each = each.value.schedule != null ? { "this" = each.value.schedule } : {}

    content {
      effective_from  = schedule.value.effective_from
      effective_until = schedule.value.effective_until
      time_zone       = schedule.value.time_zone

      dynamic "recurrence" {
        for_each = schedule.value.recurrence != null ? { "this" = schedule.value.recurrence } : {}

        content {
          dynamic "daily" {
            for_each = recurrence.value.dailies

            content {
              start_time = daily.value.start_time
              end_time   = daily.value.end_time
            }
          }

          dynamic "weekly" {
            for_each = recurrence.value.weeklies

            content {
              days_of_week = weekly.value.days_of_week
              start_time   = weekly.value.start_time
              end_time     = weekly.value.end_time
            }
          }

          dynamic "monthly" {
            for_each = recurrence.value.monthlies

            content {
              days_of_month = monthly.value.days_of_month
              start_time    = monthly.value.start_time
              end_time      = monthly.value.end_time
            }
          }
        }
      }
    }
  }
}

# prometheus alert rule groups
resource "azurerm_monitor_alert_prometheus_rule_group" "this" {
  for_each = var.alerts.alert_prometheus_rule_groups

  resource_group_name = coalesce(
    var.alerts.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.alerts.location, var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  scopes             = each.value.scopes
  cluster_name       = each.value.cluster_name
  description        = each.value.description
  rule_group_enabled = each.value.rule_group_enabled
  interval           = each.value.interval

  tags = coalesce(
    var.alerts.tags, var.tags
  )

  dynamic "rule" {
    for_each = each.value.rules

    content {
      alert       = rule.value.alert
      annotations = rule.value.annotations
      enabled     = rule.value.enabled
      expression  = rule.value.expression
      for         = rule.value.for
      labels      = rule.value.labels
      record      = rule.value.record
      severity    = rule.value.severity

      dynamic "action" {
        for_each = rule.value.actions

        content {
          action_group_id   = action.value.action_group_id
          action_properties = action.value.action_properties
        }
      }

      dynamic "alert_resolution" {
        for_each = rule.value.alert_resolution != null ? { "this" = rule.value.alert_resolution } : {}

        content {
          auto_resolved   = alert_resolution.value.auto_resolved
          time_to_resolve = alert_resolution.value.time_to_resolve
        }
      }
    }
  }
}

# smart detector alert rules
resource "azurerm_monitor_smart_detector_alert_rule" "this" {
  for_each = var.alerts.smart_detector_alert_rules

  resource_group_name = coalesce(
    var.alerts.resource_group_name, var.resource_group_name
  )

  name = coalesce(
    each.value.name, each.key
  )

  detector_type       = each.value.detector_type
  scope_resource_ids  = each.value.scope_resource_ids
  severity            = each.value.severity
  frequency           = each.value.frequency
  description         = each.value.description
  enabled             = each.value.enabled
  throttling_duration = each.value.throttling_duration

  tags = coalesce(
    var.alerts.tags, var.tags
  )

  dynamic "action_group" {
    for_each = each.value.action_group != null ? { "this" = each.value.action_group } : {}

    content {
      ids             = action_group.value.ids
      email_subject   = action_group.value.email_subject
      webhook_payload = action_group.value.webhook_payload
    }
  }
}

# scheduled query rules logs
resource "azurerm_monitor_scheduled_query_rules_log" "this" {
  for_each = var.alerts.scheduled_query_rules_logs

  resource_group_name = coalesce(
    var.alerts.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.alerts.location, var.location
  )

  name = coalesce(
    each.value.name, each.key
  )

  data_source_id          = each.value.data_source_id
  authorized_resource_ids = each.value.authorized_resource_ids
  description             = each.value.description
  enabled                 = each.value.enabled

  tags = coalesce(
    var.alerts.tags, var.tags
  )

  dynamic "criteria" {
    for_each = each.value.criteria != null ? { "this" = each.value.criteria } : {}

    content {
      metric_name = criteria.value.metric_name

      dynamic "dimension" {
        for_each = criteria.value.dimensions

        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }
}
