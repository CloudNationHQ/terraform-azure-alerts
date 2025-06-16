variable "config" {
  description = "Contains all alerts configuration"
  type = object({
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

  validation {
    condition = alltrue(flatten([
      for alert_key, alert in var.config.metrics_alerts : [
        alert.severity >= 0 && alert.severity <= 4
      ]
    ]))
    error_message = "Metric alert severity must be between 0 and 4."
  }

  validation {
    condition = alltrue(flatten([
      for alert_key, alert in var.config.metrics_alerts : [
        contains(["PT1M", "PT5M", "PT15M", "PT30M", "PT1H"], alert.frequency)
      ]
    ]))
    error_message = "Metric alert frequency must be one of: PT1M, PT5M, PT15M, PT30M, PT1H."
  }

  validation {
    condition = alltrue(flatten([
      for alert_key, alert in var.config.metrics_alerts : [
        contains(["PT1M", "PT5M", "PT15M", "PT30M", "PT1H", "PT6H", "PT12H", "P1D"], alert.window_size)
      ]
    ]))
    error_message = "Metric alert window_size must be one of: PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D."
  }
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
