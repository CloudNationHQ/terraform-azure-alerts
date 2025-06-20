module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "mag" {
  source  = "cloudnationhq/mag/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name                = "mag-demo-dev-email"
      resource_group_name = module.rg.groups.demo.name
      short_name          = "mag-email"

      email_receiver = {
        email1 = {
          name          = "send to demo"
          email_address = "email@demo-mag-email.nl"
        }
      }
    }
  }
}

module "analytics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 3.0"

  workspace = {
    name                = module.naming.log_analytics_workspace.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "alerts" {
  source  = "cloudnationhq/alerts/azure"
  version = "~> 2.0"

  config = {
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location

    metrics_alerts = {
      ma1 = {
        name        = "ma1"
        scopes      = [module.analytics.workspace.id]
        frequency   = "PT1M"
        window_size = "PT5M"

        criteria = {
          metric_namespace = "Microsoft.OperationalInsights/workspaces"
          metric_name      = "UsedCapacity"
          aggregation      = "Average"
          operator         = "LessThan"
          threshold        = 10
        }

        action = {
          action_group_id = module.mag.groups.demo.id
        }
      }
    }

    scheduled_query_rules_logs = {
      sqrl1 = {
        name           = "sqrl1"
        data_source_id = module.analytics.workspace.id
        enabled        = true
        criteria = {
          metric_name = "Average_% Idle Time"
          dimension = {
            name     = "Computer"
            operator = "Include"
            values   = ["targetVM"]
          }
        }
      }
    }
  }
}
