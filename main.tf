# metric alerts
resource "azurerm_monitor_metric_alert" "ma" {
  for_each = {
    for key, ma in lookup(var.config, "metrics_alerts", {}) : key => ma
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  name = coalesce(
    each.value.name, "ma-${each.key}"
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
    var.config.tags, var.tags
  )

  dynamic "action" {
    for_each = lookup(each.value, "action", null) != null ? [each.value.action] : []

    content {
      action_group_id    = action.value.action_group_id
      webhook_properties = action.value.webhook_properties
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
      skip_metric_validation = criteria.value.skip_metric_validation

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
      evaluation_total_count   = dynamic_criteria.value.evaluation_total_count
      evaluation_failure_count = dynamic_criteria.value.evaluation_failure_count
      ignore_data_before       = dynamic_criteria.value.ignore_data_before
      skip_metric_validation   = dynamic_criteria.value.skip_metric_validation

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

# activity log alerts
resource "azurerm_monitor_activity_log_alert" "ala" {
  for_each = {
    for key, ala in lookup(var.config, "activity_log_alerts", {}) : key => ala
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.config, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, "ala-${each.key}"
  )

  scopes      = each.value.scopes
  enabled     = each.value.enabled
  description = each.value.description

  tags = coalesce(
    var.config.tags, var.tags
  )

  dynamic "action" {
    for_each = lookup(each.value, "action", null) != null ? [each.value.action] : []

    content {
      action_group_id    = action.value.action_group_id
      webhook_properties = action.value.webhook_properties
    }
  }

  dynamic "criteria" {
    for_each = lookup(each.value, "criteria", null) != null ? [each.value.criteria] : []

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
        for_each = lookup(criteria.value, "resource_health", null) != null ? [criteria.value.resource_health] : []

        content {
          current  = resource_health.value.current
          previous = resource_health.value.previous
          reason   = resource_health.value.reason
        }
      }

      dynamic "service_health" {
        for_each = lookup(criteria.value, "service_health", null) != null ? [criteria.value.service_health] : []

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
resource "azurerm_monitor_alert_processing_rule_action_group" "aprag" {
  for_each = {
    for key, aprag in lookup(var.config, "alert_processing_rule_action_groups", {}) : key => aprag
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  name = coalesce(
    each.value.name, "aprag-${each.key}"
  )

  add_action_group_ids = each.value.add_action_group_ids
  scopes               = each.value.scopes
  description          = each.value.description
  enabled              = each.value.enabled

  tags = coalesce(
    var.config.tags, var.tags
  )

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
      effective_from  = schedule.value.effective_from
      effective_until = schedule.value.effective_until
      time_zone       = schedule.value.time_zone

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
              start_time   = weekly.value.start_time
              end_time     = weekly.value.end_time
            }
          }

          dynamic "monthly" {
            for_each = lookup(recurrence.value, "monthly", null) != null ? [recurrence.value.monthly] : []

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
resource "azurerm_monitor_alert_processing_rule_suppression" "aprs" {
  for_each = {
    for key, aprs in lookup(var.config, "alert_processing_rule_suppressions", {}) : key => aprs
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  name = coalesce(
    each.value.name, "aprs-${each.key}"
  )

  scopes      = each.value.scopes
  description = each.value.description
  enabled     = each.value.enabled

  tags = coalesce(
    var.config.tags, var.tags
  )

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
      effective_from  = schedule.value.effective_from
      effective_until = schedule.value.effective_until
      time_zone       = schedule.value.time_zone

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
              start_time   = weekly.value.start_time
              end_time     = weekly.value.end_time
            }
          }

          dynamic "monthly" {
            for_each = lookup(recurrence.value, "monthly", null) != null ? [recurrence.value.monthly] : []

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
resource "azurerm_monitor_alert_prometheus_rule_group" "aprg" {
  for_each = {
    for key, aprg in lookup(var.config, "alert_prometheus_rule_groups", {}) : key => aprg
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.config, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, "aprg-${each.key}"
  )

  scopes             = each.value.scopes
  cluster_name       = each.value.cluster_name
  description        = each.value.description
  rule_group_enabled = each.value.rule_group_enabled
  interval           = each.value.interval

  tags = coalesce(
    var.config.tags, var.tags
  )

  dynamic "rule" {
    for_each = {
      for key, rule in lookup(each.value, "rules", {}) : key => rule
    }

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
        for_each = lookup(rule.value, "action", null) != null ? [rule.value.action] : []

        content {
          action_group_id   = action.value.action_group_id
          action_properties = action.value.action_properties
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

# smart detector alert rules
resource "azurerm_monitor_smart_detector_alert_rule" "sdar" {
  for_each = {
    for key, sdar in lookup(var.config, "smart_detector_alert_rules", {}) : key => sdar
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  name = coalesce(
    each.value.name, "sdar-${each.key}"
  )

  detector_type       = each.value.detector_type
  scope_resource_ids  = each.value.scope_resource_ids
  severity            = each.value.severity
  frequency           = each.value.frequency
  description         = each.value.description
  enabled             = each.value.enabled
  throttling_duration = each.value.throttling_duration

  tags = coalesce(
    var.config.tags, var.tags
  )

  dynamic "action_group" {
    for_each = lookup(each.value, "action_group", null) != null ? [each.value.action_group] : []

    content {
      ids             = action_group.value.ids
      email_subject   = action_group.value.email_subject
      webhook_payload = action_group.value.webhook_payload
    }
  }
}

# scheduled query rules logs
resource "azurerm_monitor_scheduled_query_rules_log" "sqrl" {
  for_each = {
    for key, sqrl in lookup(var.config, "scheduled_query_rules_logs", {}) : key => sqrl
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.config, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, "sqrl-${each.key}"
  )

  data_source_id          = each.value.data_source_id
  authorized_resource_ids = each.value.authorized_resource_ids
  description             = each.value.description
  enabled                 = each.value.enabled

  tags = coalesce(
    var.config.tags, var.tags
  )

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

# # azurerm_monitor_scheduled_query_rules_alert_v2
# resource "azurerm_monitor_scheduled_query_rules_alert_v2" "sqra_v2" {
#   for_each = {
#     for key, sqra in lookup(var.config, "scheduled_query_rules_alert_v2s", {}) : key => sqra
#   }

#   name                = try(each.value.name, "sqra-${each.key}")
#   resource_group_name = coalesce(lookup(each.value, "resource_group", null), var.resource_group)
#   location            = coalesce(lookup(each.value, "location", null), var.location)

#   evaluation_frequency              = try(each.value.evaluation_frequency, null)
#   scopes                            = each.value.scopes
#   severity                          = each.value.severity
#   window_duration                   = each.value.window_duration
#   auto_mitigation_enabled           = try(each.value.auto_mitigation_enabled, false)
#   workspace_alerts_storage_enabled  = try(each.value.workspace_alerts_storage_enabled, false)
#   description                       = try(each.value.description, null)
#   display_name                      = try(each.value.display_name, null)
#   enabled                           = try(each.value.enabled, true)
#   mute_actions_after_alert_duration = try(each.value.mute_actions_after_alert_duration, null)
#   query_time_range_override         = try(each.value.query_time_range_override, null)
#   skip_query_validation             = try(each.value.skip_query_validation, false)
#   tags                              = try(each.value.tags, var.tags)
#   target_resource_types             = try(each.value.target_resource_types, null)



#   dynamic "criteria" {
#     for_each = lookup(each.value, "criteria", null) != null ? [each.value.criteria] : []
#     content {
#       operator                = criteria.value.operator
#       query                   = criteria.value.query
#       threshold               = criteria.value.threshold
#       time_aggregation_method = criteria.value.time_aggregation_method
#       metric_measure_column   = try(criteria.value.metric_measure_column, null)
#       resource_id_column      = try(criteria.value.resource_id_column, null)

#       dynamic "dimension" {
#         for_each = lookup(criteria.value, "dimension", null) != null ? [criteria.value.dimension] : []
#         content {
#           name     = dimension.value.name
#           operator = dimension.value.operator
#           values   = dimension.value.values
#         }
#       }

#       dynamic "failing_periods" {
#         for_each = lookup(criteria.value, "failing_periods", null) != null ? [criteria.value.failing_periods] : []
#         content {
#           minimum_failing_periods_to_trigger_alert = failing_periods.value.minimum_failing_periods_to_trigger_alert
#           number_of_evaluation_periods             = failing_periods.value.number_of_evaluation_periods
#         }
#       }
#     }
#   }

#   dynamic "action" {
#     for_each = lookup(each.value, "action", null) != null ? [each.value.action] : []
#     content {
#       action_groups     = try(action.value.action_groups, [])
#       custom_properties = try(action.value.custom_properties, {})
#     }
#   }

#   dynamic "identity" {
#     for_each = [lookup(each.value, "identity", { type = "SystemAssigned", identity_ids = [] })]
#     content {
#       type = identity.value.type
#       identity_ids = concat(
#         try([azurerm_user_assigned_identity.sqra_v2["identity"].id], []),
#         lookup(identity.value, "identity_ids", [])
#       )
#     }
#   }
# }

# user assigned identity
# resource "azurerm_user_assigned_identity" "sqra_v2" {
#   for_each = {
#     for item in flatten([
#       for sqra_key, sqra in var.config.scheduled_query_rules_alert_v2s : [
#         for identity_key, identity in try(sqra.identity[0], {}) : {
#           sqra_key = sqra_key
#           identity_key = identity_key
#           name = identity.name
#           resource_group_name = try(sqra.resource_group, var.resource_group)
#           location = try(sqra.location, var.location)
#           tags = try(identity.tags, var.tags)
#         }
#     ]
#     ]) : "${item.sqra_key}.${item.name}" => item
#   }

#   # name                = try(each.value.name, "uai-${each.key}")
#   name                = "uai-${each.key}"
#   resource_group_name = try(each.value.resource_group, var.resource_group)
#   location            = try(each.value.location, var.location)
#   tags                = try(each.value.tags, var.tags)
# }

# resource "azurerm_role_assignment" "sqra_v2" {
#   for_each = contains(["UserAssigned"], try(var.config.identity.type, "")) ? { "identity" = var.config.identity } : {}

#   scope                = each.value.scope
#   role_definition_name = each.value.role_definition_name
#   principal_id = azurerm_user_assigned_identity.sqra_v2["identity"].id
# }
