# module "naming" {
#   source  = "cloudnationhq/naming/azure"
#   version = "~> 0.13"

#   suffix = ["demo", "dev"]
# }

# module "rg" {
#   source  = "cloudnationhq/rg/azure"
#   version = "~> 2.0"

#   groups = {
#     demo = {
#       name     = module.naming.resource_group.name
#       location = "westeurope"
#     }
#   }
# }

# module "mag" {
#   source  = "cloudnationhq/mag/azure"
#   version = "~> 2.0"

#   groups = {
#     demo = {
#       name           = "mag-demo-dev-email"
#       resource_group = module.rg.groups.demo.name
#       short_name     = "mag-email"

#       email_receiver = {
#         email1 = {
#           name          = "send to demo"
#           email_address = "email@demo-mag-email.nl"
#         }
#       }
#     }
#   }
# }

# module "appi" {
#   source  = "cloudnationhq/appi/azure"
#   version = "~> 2.0"

#   config = {
#     name             = module.naming.application_insights.name
#     resource_group   = module.rg.groups.demo.name
#     location         = module.rg.groups.demo.location
#     application_type = "web"
#   }
# }

# module "alerts" {
#   source  = "cloudnationhq/alerts/azure"
#   version = "~> 1.0"

#   resource_group = module.rg.groups.demo.name
#   location       = module.rg.groups.demo.location
#   config = {
#     scheduled_query_rules_alert_v2s = {
#       sqra_v2_1 = {
#         name           = "sqra_v2_1"
#         evaluation_frequency = "PT10M"
#         window_duration      = "PT10M"
#         scopes               = [module.appi.config.id]
#         severity             = 4
#         criteria = {
#           query                   = <<-QUERY
#             requests
#               | summarize CountByCountry=count() by client_CountryOrRegion
#             QUERY
#           time_aggregation_method = "Maximum"
#           threshold               = 17.5
#           operator                = "LessThan"

#           resource_id_column    = "client_CountryOrRegion"
#           metric_measure_column = "CountByCountry"
#           dimension = {
#             name     = "client_CountryOrRegion"
#             operator = "Exclude"
#             values   = ["123"]
#           }
#           failing_periods = {
#             minimum_failing_periods_to_trigger_alert = 1
#             number_of_evaluation_periods             = 1
#           }
#         }

#         auto_mitigation_enabled          = true
#         workspace_alerts_storage_enabled = false
#         enabled                          = true
#         query_time_range_override        = "PT1H"
#         skip_query_validation            = true
#         action = {
#           action_groups = [module.mag.groups.demo.id]
#           custom_properties = {
#             key  = "value"
#             key2 = "value2"
#           }
#         }
#         identity = {
#           type = "UserAssigned"
#         }
#       }
#     }
#   }
# }
