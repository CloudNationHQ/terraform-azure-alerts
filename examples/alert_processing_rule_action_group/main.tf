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

module "alerts" {
  source = "../../"

  config = {
    alert_processing_rule_action_groups = {
      aprag1 = {
        name                 = "aprag1"
        resource_group       = module.rg.groups.demo.name
        scopes               = [module.rg.groups.demo.id]
        add_action_group_ids = [module.mag.groups.demo.id]
        condition = {
          target_resource_type = {
            operator = "Equals"
            values   = ["Microsoft.Compute/VirtualMachines"]
          }
          severity = {
            operator = "Equals"
            values   = ["Sev0", "Sev1", "Sev2"]
          }
        }

        schedule = {
          effective_from  = "2022-01-01T01:02:03"
          effective_until = "2022-02-02T01:02:03"
          time_zone       = "Central Europe Standard Time"
          recurrence = {
            daily = {
              start_time = "17:00:00"
              end_time   = "09:00:00"
            }
            weekly = {
              days_of_week = ["Saturday", "Sunday"]
            }
          }
        }
      }
    }
  }
}
