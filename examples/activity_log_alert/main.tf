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
    activity_log_alerts = {
      ala1 = {
        name           = "ala1"
        resource_group = module.rg.groups.demo.name
        location       = module.rg.groups.demo.location
        scopes         = [module.rg.groups.demo.id]

        criteria = {
          resource_id    = module.storage.account.id
          operation_name = "Microsoft.Storage/storageAccounts/write"
          category       = "Recommendation"
        }

        action = {
          action_group_id = module.mag.groups.demo.id

          webhook_properties = {
            from = "terraform"
          }
        }
      }
    }
  }
}
