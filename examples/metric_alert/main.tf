module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.13"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 2.0"

  storage = {
    name           = module.naming.storage_account.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}


module "mag" {
  source  = "cloudnationhq/mag/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name           = "mag-demo-dev-email"
      resource_group = module.rg.groups.demo.name
      short_name     = "mag-email"

      email_receiver = {
        email1 = {
          name          = "send to demo"
          email_address = "email@demo-mag-email.nl"
        }
      }
    }
  }
}

module "alerts" {
  source = "../../"

  config = {
    metrics_alert = {
      ma1 = {
        name           = "ma1"
        resource_group = module.rg.groups.demo.name
        scopes         = [module.storage.account.id]
        criteria = {
          metric_namespace = "Microsoft.Storage/storageAccounts"
          metric_name      = "Transactions"
          aggregation      = "Total"
          operator         = "GreaterThan"
          threshold        = 50

          dimension = {
            name     = "ApiName"
            operator = "Include"
            values   = ["*"]
          }
        }

        action_group = {
          action_group_id = module.mag.groups.demo.id
        }
      }
    }
  }
}
