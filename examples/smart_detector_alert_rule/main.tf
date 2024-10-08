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

module "appi" {
  source  = "cloudnationhq/appi/azure"
  version = "~> 2.0"

  config = {
    name             = module.naming.application_insights.name
    resource_group   = module.rg.groups.demo.name
    location         = module.rg.groups.demo.location
    application_type = "web"
  }
}

module "alerts" {
  source = "../../"

  config = {
    smart_detector_alert_rules = {
      sdar1 = {
        name               = "sdar1"
        resource_group     = module.rg.groups.demo.name
        severity           = "Sev0"
        scope_resource_ids = [module.appi.config.id]
        frequency          = "PT1M"
        detector_type      = "FailureAnomaliesDetector"

        action_group = {
          ids = [module.mag.groups.demo.id]
        }
      }
    }
  }
}
