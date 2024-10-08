# azurerm_monitor_metric_alert
resource "azurerm_monitor_metric_alert" "ma" {
  for_each = {
    for key, ma in lookup(var.config, "metrics_alerts", {}) : key => ma
  }

  name                     = try(each.value.name, "ma-${each.key}")
  resource_group_name      = coalesce(lookup(each.value, "resource_group", null), var.resource_group)
  scopes                   = each.value.scopes
  enabled                  = try(each.value.enabled, true)
  auto_mitigate            = try(each.value.auto_mitigate, true)
  description              = try(each.value.description, null)
  frequency                = try(each.value.frequency, "PT1M")
  severity                 = try(each.value.severity, 3)
  target_resource_type     = try(each.value.target_resource_type, null)
  target_resource_location = try(each.value.target_resource_location, null)
  window_size              = try(each.value.window_size, "PT5M")
  tags                     = try(each.value.tags, var.tags)

  dynamic "action" {
    for_each = lookup(each.value, "action", null) != null ? [each.value.action] : []
    content {
      action_group_id    = action.value.action_group_id
      webhook_properties = try(action.value.webhook_properties, null)
    }
  }

  dynamic "criteria" {
    for_each = lookup(each.value, "criteria", null) != null ? [each.value.criteria] : []
    content {
      metric_namespace       = criteria.value.metric_namespace
      metric_name            = criteria.value.metric_name
      aggregation            = criteria.value.aggregation
      operator               = criteria.value.operator
      threshold              = criteria.value.threshold
      skip_metric_validation = try(criteria.value.skip_metric_validation, false)

      dynamic "dimension" {
        for_each = lookup(criteria.value, "dimension", null) != null ? [criteria.value.dimension] : []
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }

  dynamic "dynamic_criteria" {
    for_each = lookup(each.value, "dynamic_criteria", null) != null ? [each.value.dynamic_criteria] : []
    content {
      metric_namespace         = dynamic_criteria.value.metric_namespace
      metric_name              = dynamic_criteria.value.metric_name
      aggregation              = dynamic_criteria.value.aggregation
      operator                 = dynamic_criteria.value.operator
      alert_sensitivity        = dynamic_criteria.value.alert_sensitivity
      evaluation_total_count   = try(dynamic_criteria.value.evaluation_total_count, 4)
      evaluation_failure_count = try(dynamic_criteria.value.evaluation_failure_count, 4)
      ignore_data_before       = try(dynamic_criteria.value.ignore_data_before, null)
      skip_metric_validation   = try(dynamic_criteria.value.skip_metric_validation, null)

      dynamic "dimension" {
        for_each = lookup(dynamic_criteria.value, "dimension", null) != null ? [dynamic_criteria.value.dimension] : []
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }

  dynamic "application_insights_web_test_location_availability_criteria" {
    for_each = lookup(each.value, "application_insights_web_test_location_availability_criteria", null) != null ? [each.value.application_insights_web_test_location_availability_criteria] : []
    content {
      web_test_id           = application_insights_web_test_location_availability_criteria.value.web_test_id
      component_id          = application_insights_web_test_location_availability_criteria.value.component_id
      failed_location_count = application_insights_web_test_location_availability_criteria.value.failed_location_count
    }
  }
}

# azurerm_monitor_activity_log_alert
resource "azurerm_monitor_activity_log_alert" "ala" {
  for_each = {
    for key, ma in lookup(var.config, "activity_log_alerts", {}) : key => ma
  }

  name                = try(each.value.name, "ala-${each.key}")
  resource_group_name = coalesce(lookup(each.value, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(each.value, "location", null), var.location)
  scopes              = each.value.scopes
  enabled             = try(each.value.enabled, true)
  description         = try(each.value.description, null)
  tags                = try(each.value.tags, var.tags)

  dynamic "action" {
    for_each = lookup(each.value, "action", null) != null ? [each.value.action] : []
    content {
      action_group_id    = action.value.action_group_id
      webhook_properties = try(action.value.webhook_properties, null)
    }
  }

  dynamic "criteria" {
    for_each = lookup(each.value, "criteria", null) != null ? [each.value.criteria] : []
    content {
      category                = criteria.value.category
      caller                  = try(criteria.value.caller, null)
      operation_name          = try(criteria.value.operation_name, null)
      resource_provider       = try(criteria.value.resource_provider, null)
      resource_providers      = try(criteria.value.resource_providers, null)
      resource_type           = try(criteria.value.resource_type, null)
      resource_types          = try(criteria.value.resource_types, null)
      resource_group          = try(criteria.value.resource_group, null)
      resource_groups         = try(criteria.value.resource_groups, null)
      resource_id             = try(criteria.value.resource_id, null)
      resource_ids            = try(criteria.value.resource_ids, null)
      level                   = try(criteria.value.level, null)
      levels                  = try(criteria.value.levels, null)
      status                  = try(criteria.value.status, null)
      statuses                = try(criteria.value.statuses, null)
      sub_status              = try(criteria.value.sub_status, null)
      sub_statuses            = try(criteria.value.sub_statuses, null)
      recommendation_type     = try(criteria.value.recommendation_type, null)
      recommendation_category = try(criteria.value.recommendation_category, null)
      recommendation_impact   = try(criteria.value.recommendation_impact, null)

      dynamic "resource_health" {
        for_each = lookup(criteria.value, "resource_health", null) != null ? [criteria.value.resource_health] : []
        content {
          current  = try(resource_health.value.current, null)
          previous = try(resource_health.value.previous, null)
          reason   = try(resource_health.value.reason, null)
        }
      }

      dynamic "service_health" {
        for_each = lookup(criteria.value, "service_health", null) != null ? [criteria.value.service_health] : []
        content {
          events    = try(service_health.value.events, null)
          locations = try(service_health.value.locations, null)
          services  = try(service_health.value.services, null)
        }
      }
    }
  }
}

# azurerm_monitor_alert_processing_rule_action_group
resource "azurerm_monitor_alert_processing_rule_action_group" "aprag" {
  for_each = {
    for key, ma in lookup(var.config, "alert_processing_rule_action_groups", {}) : key => ma
  }

  add_action_group_ids = each.value.add_action_group_ids
  name                 = try(each.value.name, "aprag-${each.key}")
  resource_group_name  = coalesce(lookup(each.value, "resource_group", null), var.resource_group)
  scopes               = each.value.scopes
  description          = try(each.value.description, null)
  tags                 = try(each.value.tags, var.tags)

  dynamic "condition" {
    for_each = lookup(each.value, "condition", null) != null ? [each.value.condition] : []
    content {
      dynamic "alert_context" {
        for_each = lookup(condition.value, "alert_context", null) != null ? [condition.value.alert_context] : []
        content {
          operator = alert_context.value.operator
          values   = alert_context.value.values
        }
      }

      dynamic "alert_rule_id" {
        for_each = lookup(condition.value, "alert_rule_id", null) != null ? [condition.value.alert_rule_id] : []
        content {
          operator = alert_rule_id.value.operator
          values   = alert_rule_id.value.values
        }
      }

      dynamic "alert_rule_name" {
        for_each = lookup(condition.value, "alert_rule_name", null) != null ? [condition.value.alert_rule_name] : []
        content {
          operator = alert_rule_name.value.operator
          values   = alert_rule_name.value.values
        }
      }

      dynamic "description" {
        for_each = lookup(condition.value, "description", null) != null ? [condition.value.description] : []
        content {
          operator = description.value.operator
          values   = description.value.values
        }
      }

      dynamic "monitor_condition" {
        for_each = lookup(condition.value, "monitor_condition", null) != null ? [condition.value.monitor_condition] : []
        content {
          operator = monitor_condition.value.operator
          values   = monitor_condition.value.values
        }
      }

      dynamic "monitor_service" {
        for_each = lookup(condition.value, "monitor_service", null) != null ? [condition.value.monitor_service] : []
        content {
          operator = monitor_service.value.operator
          values   = monitor_service.value.values
        }
      }

      dynamic "severity" {
        for_each = lookup(condition.value, "severity", null) != null ? [condition.value.severity] : []
        content {
          operator = severity.value.operator
          values   = severity.value.values
        }
      }

      dynamic "signal_type" {
        for_each = lookup(condition.value, "signal_type", null) != null ? [condition.value.signal_type] : []
        content {
          operator = signal_type.value.operator
          values   = signal_type.value.values
        }
      }

      dynamic "target_resource" {
        for_each = lookup(condition.value, "target_resource", null) != null ? [condition.value.target_resource] : []
        content {
          operator = target_resource.value.operator
          values   = target_resource.value.values
        }
      }

      dynamic "target_resource_group" {
        for_each = lookup(condition.value, "target_resource_group", null) != null ? [condition.value.target_resource_group] : []
        content {
          operator = target_resource_group.value.operator
          values   = target_resource_group.value.values
        }
      }

      dynamic "target_resource_type" {
        for_each = lookup(condition.value, "target_resource_type", null) != null ? [condition.value.target_resource_type] : []
        content {
          operator = target_resource_type.value.operator
          values   = target_resource_type.value.values
        }
      }
    }
  }

  dynamic "schedule" {
    for_each = lookup(each.value, "schedule", null) != null ? [each.value.schedule] : []

    content {
      effective_from  = try(schedule.value.effective_from, null)
      effective_until = try(schedule.value.effective_until, null)
      time_zone       = try(schedule.value.time_zone, "UTC")

      dynamic "recurrence" {
        for_each = lookup(schedule.value, "recurrence", null) != null ? [schedule.value.recurrence] : []
        content {
          dynamic "daily" {
            for_each = lookup(recurrence.value, "daily", null) != null ? [recurrence.value.daily] : []
            content {
              start_time = daily.value.start_time
              end_time   = daily.value.end_time
            }
          }

          dynamic "weekly" {
            for_each = lookup(recurrence.value, "weekly", null) != null ? [recurrence.value.weekly] : []
            content {
              days_of_week = weekly.value.days_of_week
              start_time   = try(weekly.value.start_time, null)
              end_time     = try(weekly.value.end_time, null)
            }
          }

          dynamic "monthly" {
            for_each = lookup(recurrence.value, "monthly", null) != null ? [recurrence.value.monthly] : []
            content {
              days_of_month = monthly.value.days_of_month
              start_time    = try(monthly.value.start_time, null)
              end_time      = try(monthly.value.end_time, null)
            }
          }
        }
      }
    }
  }
}

# azurerm_monitor_alert_processing_rule_suppression
resource "azurerm_monitor_alert_processing_rule_suppression" "aprs" {
  for_each = {
    for key, ma in lookup(var.config, "alert_processing_rule_suppressions", {}) : key => ma
  }

  name                = try(each.value.name, "aprs-${each.key}")
  resource_group_name = coalesce(lookup(each.value, "resource_group", null), var.resource_group)
  scopes              = each.value.scopes
  description         = try(each.value.description, null)
  enabled             = try(each.value.enabled, true)
  tags                = try(each.value.tags, var.tags)

  dynamic "condition" {
    for_each = lookup(each.value, "condition", null) != null ? [each.value.condition] : []
    content {
      dynamic "alert_context" {
        for_each = lookup(condition.value, "alert_context", null) != null ? [condition.value.alert_context] : []
        content {
          operator = alert_context.value.operator
          values   = alert_context.value.values
        }
      }

      dynamic "alert_rule_id" {
        for_each = lookup(condition.value, "alert_rule_id", null) != null ? [condition.value.alert_rule_id] : []
        content {
          operator = alert_rule_id.value.operator
          values   = alert_rule_id.value.values
        }
      }

      dynamic "alert_rule_name" {
        for_each = lookup(condition.value, "alert_rule_name", null) != null ? [condition.value.alert_rule_name] : []
        content {
          operator = alert_rule_name.value.operator
          values   = alert_rule_name.value.values
        }
      }

      dynamic "description" {
        for_each = lookup(condition.value, "description", null) != null ? [condition.value.description] : []
        content {
          operator = description.value.operator
          values   = description.value.values
        }
      }

      dynamic "monitor_condition" {
        for_each = lookup(condition.value, "monitor_condition", null) != null ? [condition.value.monitor_condition] : []
        content {
          operator = monitor_condition.value.operator
          values   = monitor_condition.value.values
        }
      }

      dynamic "monitor_service" {
        for_each = lookup(condition.value, "monitor_service", null) != null ? [condition.value.monitor_service] : []
        content {
          operator = monitor_service.value.operator
          values   = monitor_service.value.values
        }
      }

      dynamic "severity" {
        for_each = lookup(condition.value, "severity", null) != null ? [condition.value.severity] : []
        content {
          operator = severity.value.operator
          values   = severity.value.values
        }
      }

      dynamic "signal_type" {
        for_each = lookup(condition.value, "signal_type", null) != null ? [condition.value.signal_type] : []
        content {
          operator = signal_type.value.operator
          values   = signal_type.value.values
        }
      }

      dynamic "target_resource" {
        for_each = lookup(condition.value, "target_resource", null) != null ? [condition.value.target_resource] : []
        content {
          operator = target_resource.value.operator
          values   = target_resource.value.values
        }
      }

      dynamic "target_resource_group" {
        for_each = lookup(condition.value, "target_resource_group", null) != null ? [condition.value.target_resource_group] : []
        content {
          operator = target_resource_group.value.operator
          values   = target_resource_group.value.values
        }
      }

      dynamic "target_resource_type" {
        for_each = lookup(condition.value, "target_resource_type", null) != null ? [condition.value.target_resource_type] : []
        content {
          operator = target_resource_type.value.operator
          values   = target_resource_type.value.values
        }
      }
    }
  }

  dynamic "schedule" {
    for_each = lookup(each.value, "schedule", null) != null ? [each.value.schedule] : []

    content {
      effective_from  = try(schedule.value.effective_from, null)
      effective_until = try(schedule.value.effective_until, null)
      time_zone       = try(schedule.value.time_zone, "UTC")

      dynamic "recurrence" {
        for_each = lookup(schedule.value, "recurrence", null) != null ? [schedule.value.recurrence] : []
        content {
          dynamic "daily" {
            for_each = lookup(recurrence.value, "daily", null) != null ? [recurrence.value.daily] : []
            content {
              start_time = daily.value.start_time
              end_time   = daily.value.end_time
            }
          }

          dynamic "weekly" {
            for_each = lookup(recurrence.value, "weekly", null) != null ? [recurrence.value.weekly] : []
            content {
              days_of_week = weekly.value.days_of_week
              start_time   = try(weekly.value.start_time, null)
              end_time     = try(weekly.value.end_time, null)
            }
          }

          dynamic "monthly" {
            for_each = lookup(recurrence.value, "monthly", null) != null ? [recurrence.value.monthly] : []
            content {
              days_of_month = monthly.value.days_of_month
              start_time    = try(monthly.value.start_time, null)
              end_time      = try(monthly.value.end_time, null)
            }
          }
        }
      }
    }
  }
}

# azurerm_monitor_alert_prometheus_rule_group
resource "azurerm_monitor_alert_prometheus_rule_group" "aprg" {
  for_each = {
    for key, ma in lookup(var.config, "alert_prometheus_rule_groups", {}) : key => ma
  }

  name                = try(each.value.name, "aprg-${each.key}")
  location            = coalesce(lookup(each.value, "location", null), var.location)
  resource_group_name = coalesce(lookup(each.value, "resource_group", null), var.resource_group)
  scopes              = each.value.scopes
  cluster_name        = try(each.value.cluster_name, null)
  description         = try(each.value.description, null)
  rule_group_enabled  = try(each.value.rule_group_enabled, null)
  interval            = try(each.value.interval, null)
  tags                = try(each.value.tags, var.tags)

  dynamic "rule" {
    for_each = {
      for key, rule in lookup(each.value, "rules", {}) : key => rule
    }
    content {
      alert       = try(rule.value.alert, null)
      annotations = try(rule.value.annotations, null)
      enabled     = try(rule.value.enabled, true)
      expression  = rule.value.expression
      for         = try(rule.value.for, null)
      labels      = try(rule.value.labels, null)
      record      = try(rule.value.record, null)
      severity    = try(rule.value.severity, null)

      dynamic "action" {
        for_each = lookup(rule.value, "action", null) != null ? [rule.value.action] : []
        content {
          action_group_id   = action.value.action_group_id
          action_properties = try(action.value.action_properties, null)
        }
      }

      dynamic "alert_resolution" {
        for_each = lookup(rule.value, "alert_resolution", null) != null ? [rule.value.alert_resolution] : []
        content {
          auto_resolved   = alert_resolution.value.auto_resolved
          time_to_resolve = alert_resolution.value.time_to_resolve
        }
      }
    }
  }
}

# azurerm_monitor_smart_detector_alert_rule
resource "azurerm_monitor_smart_detector_alert_rule" "sdar" {
  for_each = {
    for key, ma in lookup(var.config, "smart_detector_alert_rules", {}) : key => ma
  }

  name                = try(each.value.name, "sdar-${each.key}")
  resource_group_name = coalesce(lookup(each.value, "resource_group", null), var.resource_group)
  detector_type       = each.value.detector_type
  scope_resource_ids  = each.value.scope_resource_ids
  severity            = each.value.severity
  frequency           = each.value.frequency
  description         = try(each.value.description, null)
  enabled             = try(each.value.enabled, true)
  throttling_duration = try(each.value.throttling_duration, null)
  tags                = try(each.value.tags, var.tags)

  dynamic "action_group" {
    for_each = lookup(each.value, "action_group", null) != null ? [each.value.action_group] : []
    content {
      ids             = action_group.value.ids
      email_subject   = try(action_group.value.email_subject, null)
      webhook_payload = try(action_group.value.webhook_payload, null)
    }
  }
}

# azurerm_monitor_scheduled_query_rules_alert_v2
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "sqra_v2" {
  for_each = {
    for key, ma in lookup(var.config, "scheduled_query_rules_alert_v2s", {}) : key => ma
  }

  name                = try(each.value.name, "sqra-${each.key}")
  resource_group_name = coalesce(lookup(each.value, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(each.value, "location", null), var.location)

  evaluation_frequency              = try(each.value.evaluation_frequency, null)
  scopes                            = each.value.scopes
  severity                          = each.value.severity
  window_duration                   = each.value.window_duration
  auto_mitigation_enabled           = try(each.value.auto_mitigation_enabled, false)
  workspace_alerts_storage_enabled  = try(each.value.workspace_alerts_storage_enabled, false)
  description                       = try(each.value.description, null)
  display_name                      = try(each.value.display_name, null)
  enabled                           = try(each.value.enabled, true)
  mute_actions_after_alert_duration = try(each.value.mute_actions_after_alert_duration, null)
  query_time_range_override         = try(each.value.query_time_range_override, null)
  skip_query_validation             = try(each.value.skip_query_validation, false)
  tags                              = try(each.value.tags, var.tags)
  target_resource_types             = try(each.value.target_resource_types, null)



  dynamic "criteria" {
    for_each = lookup(each.value, "criteria", null) != null ? [each.value.criteria] : []
    content {
      operator                = criteria.value.operator
      query                   = criteria.value.query
      threshold               = criteria.value.threshold
      time_aggregation_method = criteria.value.time_aggregation_method
      metric_measure_column   = try(criteria.value.metric_measure_column, null)
      resource_id_column      = try(criteria.value.resource_id_column, null)

      dynamic "dimension" {
        for_each = lookup(criteria.value, "dimension", null) != null ? [criteria.value.dimension] : []
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }

      dynamic "failing_periods" {
        for_each = lookup(criteria.value, "failing_periods", null) != null ? [criteria.value.failing_periods] : []
        content {
          minimum_failing_periods_to_trigger_alert = failing_periods.value.minimum_failing_periods_to_trigger_alert
          number_of_evaluation_periods             = failing_periods.value.number_of_evaluation_periods
        }
      }
    }
  }

  dynamic "action" {
    for_each = lookup(each.value, "action", null) != null ? [each.value.action] : []
    content {
      action_groups     = try(action.value.action_groups, [])
      custom_properties = try(action.value.custom_properties, {})
    }
  }

  dynamic "identity" {
    for_each = [lookup(each.value, "identity", { type = "SystemAssigned", identity_ids = [] })]
    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.sqra_v2["identity"].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }
}

# azurerm_monitor_scheduled_query_rules_log
resource "azurerm_monitor_scheduled_query_rules_log" "sqrl" {
  for_each = {
    for key, ma in lookup(var.config, "scheduled_query_rules_logs", {}) : key => ma
  }

  name                    = try(each.value.name, "sqrl-${each.key}")
  location                = coalesce(lookup(each.value, "location", null), var.location)
  resource_group_name     = coalesce(lookup(each.value, "resource_group", null), var.resource_group)
  data_source_id          = each.value.data_source_id
  authorized_resource_ids = try(each.value.authorized_resource_ids, null)
  description             = try(each.value.description, null)
  enabled                 = try(each.value.enabled, true)
  tags                    = try(each.value.tags, var.tags)

  dynamic "criteria" {
    for_each = lookup(each.value, "criteria", null) != null ? [each.value.criteria] : []
    content {
      metric_name = criteria.value.metric_name

      dynamic "dimension" {
        for_each = lookup(criteria.value, "dimension", null) != null ? [criteria.value.dimension] : []
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }
}

# user assigned identity
resource "azurerm_user_assigned_identity" "sqra_v2" {
  for_each = contains(["UserAssigned"], try(var.config.identity.type, "")) ? { "identity" = var.config.identity } : {}

  name                = try(each.value.identity.name, "uai-${each.key}")
  resource_group_name = try(each.value.identity.resource_group_name, var.resource_group)
  location            = try(each.value.location, var.location)
  tags                = try(each.value.identity.tags, var.tags)
}

resource "azurerm_role_assignment" "sqra_v2" {
  for_each = contains(["UserAssigned"], try(var.config.identity.type, "")) ? { "identity" = var.config.identity } : {}

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id = azurerm_user_assigned_identity.sqra_v2["identity"].id
}