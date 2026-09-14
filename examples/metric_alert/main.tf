module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.32"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 5.0"

  storage = {
    name                = module.naming.storage_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}


module "mag" {
  source  = "cloudnationhq/mag/azure"
  version = "~> 4.0"

  groups = {
    demo = {
      name                = "mag-demo-dev-email"
      resource_group_name = module.rg.groups.demo.name
      location            = "global"
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

module "alerts" {
  source  = "cloudnationhq/alerts/azure"
  version = "~> 3.0"

  alerts = {
    resource_group_name = module.rg.groups.demo.name

    metrics_alerts = {
      ma1 = {
        name   = "ma1"
        scopes = [module.storage.account.id]
        criteria = {
          transactions = {
            metric_namespace = "Microsoft.Storage/storageAccounts"
            metric_name      = "Transactions"
            aggregation      = "Total"
            operator         = "GreaterThan"
            threshold        = 50

            dimensions = {
              api_name = {
                name     = "ApiName"
                operator = "Include"
                values   = ["*"]
              }
            }
          }
        }

        actions = {
          demo = {
            action_group_id = module.mag.groups.demo.id
          }
        }
      }
    }
  }
}
