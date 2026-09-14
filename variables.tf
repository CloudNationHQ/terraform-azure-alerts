variable "alerts" {
  description = "Contains all alerts configuration"
  type = object({
    resource_group_name = optional(string)
    location            = optional(string)
    tags                = optional(map(string))
    metrics_alerts = optional(map(object({
      name                     = optional(string)
      scopes                   = list(string)
      enabled                  = optional(bool, true)
      auto_mitigate            = optional(bool, true)
      description              = optional(string)
      frequency                = optional(string, "PT1M")
      severity                 = optional(number, 3)
      target_resource_type     = optional(string)
      target_resource_location = optional(string)
      window_size              = optional(string, "PT5M")
      actions = optional(map(object({
        action_group_id    = string
        webhook_properties = optional(map(string))
      })), {})
      criteria = optional(map(object({
        metric_namespace       = string
        metric_name            = string
        aggregation            = string
        operator               = string
        threshold              = number
        skip_metric_validation = optional(bool)
        dimensions = optional(map(object({
          name     = string
          operator = string
          values   = list(string)
        })), {})
      })), {})
      dynamic_criteria = optional(object({
        metric_namespace         = string
        metric_name              = string
        aggregation              = string
        operator                 = string
        alert_sensitivity        = string
        evaluation_total_count   = optional(number)
        evaluation_failure_count = optional(number)
        ignore_data_before       = optional(string)
        skip_metric_validation   = optional(bool)
        dimensions = optional(map(object({
          name     = string
          operator = string
          values   = list(string)
        })), {})
      }))
      application_insights_web_test_location_availability_criteria = optional(object({
        web_test_id           = string
        component_id          = string
        failed_location_count = number
      }))
    })), {})
    activity_log_alerts = optional(map(object({
      name        = optional(string)
      scopes      = list(string)
      enabled     = optional(bool, true)
      description = optional(string)
      actions = optional(map(object({
        action_group_id    = string
        webhook_properties = optional(map(string))
      })), {})
      criteria = optional(object({
        category                = string
        caller                  = optional(string)
        operation_name          = optional(string)
        resource_provider       = optional(string)
        resource_providers      = optional(list(string))
        resource_type           = optional(string)
        resource_types          = optional(list(string))
        resource_group          = optional(string)
        resource_groups         = optional(list(string))
        resource_id             = optional(string)
        resource_ids            = optional(list(string))
        level                   = optional(string)
        levels                  = optional(list(string))
        status                  = optional(string)
        statuses                = optional(list(string))
        sub_status              = optional(string)
        sub_statuses            = optional(list(string))
        recommendation_type     = optional(string)
        recommendation_category = optional(string)
        recommendation_impact   = optional(string)
        resource_health = optional(object({
          current  = optional(list(string))
          previous = optional(list(string))
          reason   = optional(list(string))
        }))
        service_health = optional(object({
          events    = optional(list(string))
          locations = optional(list(string))
          services  = optional(list(string))
        }))
      }))
    })), {})
    alert_processing_rule_action_groups = optional(map(object({
      add_action_group_ids = list(string)
      name                 = optional(string)
      scopes               = list(string)
      description          = optional(string)
      enabled              = optional(bool, true)
      condition = optional(object({
        alert_context = optional(object({
          operator = string
          values   = list(string)
        }))
        alert_rule_id = optional(object({
          operator = string
          values   = list(string)
        }))
        alert_rule_name = optional(object({
          operator = string
          values   = list(string)
        }))
        description = optional(object({
          operator = string
          values   = list(string)
        }))
        monitor_condition = optional(object({
          operator = string
          values   = list(string)
        }))
        monitor_service = optional(object({
          operator = string
          values   = list(string)
        }))
        severity = optional(object({
          operator = string
          values   = list(string)
        }))
        signal_type = optional(object({
          operator = string
          values   = list(string)
        }))
        target_resource = optional(object({
          operator = string
          values   = list(string)
        }))
        target_resource_group = optional(object({
          operator = string
          values   = list(string)
        }))
        target_resource_type = optional(object({
          operator = string
          values   = list(string)
        }))
      }))
      schedule = optional(object({
        effective_from  = optional(string)
        effective_until = optional(string)
        time_zone       = optional(string)
        recurrence = optional(object({
          dailies = optional(map(object({
            start_time = string
            end_time   = string
          })), {})
          weeklies = optional(map(object({
            days_of_week = list(string)
            start_time   = optional(string)
            end_time     = optional(string)
          })), {})
          monthlies = optional(map(object({
            days_of_month = list(number)
            start_time    = optional(string)
            end_time      = optional(string)
          })), {})
        }))
      }))
    })), {})
    alert_processing_rule_suppressions = optional(map(object({
      name        = optional(string)
      scopes      = list(string)
      description = optional(string)
      enabled     = optional(bool, true)
      condition = optional(object({
        alert_context = optional(object({
          operator = string
          values   = list(string)
        }))
        alert_rule_id = optional(object({
          operator = string
          values   = list(string)
        }))
        alert_rule_name = optional(object({
          operator = string
          values   = list(string)
        }))
        description = optional(object({
          operator = string
          values   = list(string)
        }))
        monitor_condition = optional(object({
          operator = string
          values   = list(string)
        }))
        monitor_service = optional(object({
          operator = string
          values   = list(string)
        }))
        severity = optional(object({
          operator = string
          values   = list(string)
        }))
        signal_type = optional(object({
          operator = string
          values   = list(string)
        }))
        target_resource = optional(object({
          operator = string
          values   = list(string)
        }))
        target_resource_group = optional(object({
          operator = string
          values   = list(string)
        }))
        target_resource_type = optional(object({
          operator = string
          values   = list(string)
        }))
      }))
      schedule = optional(object({
        effective_from  = optional(string)
        effective_until = optional(string)
        time_zone       = optional(string)
        recurrence = optional(object({
          dailies = optional(map(object({
            start_time = string
            end_time   = string
          })), {})
          weeklies = optional(map(object({
            days_of_week = list(string)
            start_time   = optional(string)
            end_time     = optional(string)
          })), {})
          monthlies = optional(map(object({
            days_of_month = list(number)
            start_time    = optional(string)
            end_time      = optional(string)
          })), {})
        }))
      }))
    })), {})
    alert_prometheus_rule_groups = optional(map(object({
      name               = optional(string)
      location           = optional(string)
      scopes             = list(string)
      cluster_name       = optional(string)
      description        = optional(string)
      rule_group_enabled = optional(bool, true)
      interval           = optional(string, "PT1M")
      rules = optional(map(object({
        alert       = optional(string)
        annotations = optional(map(string))
        enabled     = optional(bool, true)
        expression  = string
        for         = optional(string)
        labels      = optional(map(string))
        record      = optional(string)
        severity    = optional(number)
        actions = optional(map(object({
          action_group_id   = string
          action_properties = optional(map(string))
        })), {})
        alert_resolution = optional(object({
          auto_resolved   = bool
          time_to_resolve = string
        }))
      })), {})
    })), {})
    smart_detector_alert_rules = optional(map(object({
      name                = optional(string)
      detector_type       = string
      scope_resource_ids  = list(string)
      severity            = string
      frequency           = string
      description         = optional(string)
      enabled             = optional(bool, true)
      throttling_duration = optional(string)
      action_group = optional(object({
        ids             = list(string)
        email_subject   = optional(string)
        webhook_payload = optional(string)
      }))
    })), {})
    scheduled_query_rules_logs = optional(map(object({
      name                    = optional(string)
      location                = optional(string)
      data_source_id          = string
      authorized_resource_ids = optional(list(string))
      description             = optional(string)
      enabled                 = optional(bool, true)
      criteria = optional(object({
        metric_name = string
        dimensions = optional(map(object({
          name     = string
          operator = string
          values   = list(string)
        })), {})
      }))
    })), {})
  })
}

variable "resource_group_name" {
  description = "Default resource group name"
  type        = string
  default     = null
}

variable "location" {
  description = "Default Azure region"
  type        = string
  default     = null
}

variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
}
