module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.25"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "northeurope"
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

module "monitor_workspace" {
  source  = "cloudnationhq/alerts/azure//modules/monitor_workspace"
  version = "~> 2.0"

  workspace = {
    name                = "mw-demo"
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 4.0"

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "identity" {
  source  = "cloudnationhq/uai/azure"
  version = "~> 2.0"

  config = {
    name                = module.naming.user_assigned_identity.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 4.0"

  keyvault = module.kv.vault.id

  cluster = {
    name                = module.naming.kubernetes_cluster.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    depends_on          = [module.kv]
    profile             = "linux"
    dns_prefix          = "demo"

    generate_ssh_key = {
      enable = true
    }

    identity = {
      type         = "UserAssigned"
      identity_ids = [module.identity.config.id]
    }

    default_node_pool = {
      upgrade_settings = {
        max_surge = "10%"
      }
    }
  }
}

module "alerts" {
  source  = "cloudnationhq/alerts/azure"
  version = "~> 2.0"

  config = {
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location

    alert_prometheus_rule_groups = {
      aprg1 = {
        name               = "aprg1"
        cluster_name       = module.aks.cluster.name
        rule_group_enabled = false
        interval           = "PT1M"
        scopes             = [module.monitor_workspace.workspace.id]
        rules = {
          rule1 = {
            enabled    = false
            expression = <<EOF
            histogram_quantile(0.99, sum(rate(jobs_duration_seconds_bucket{service="billing-processing"}[5m])) by (job_type))
            EOF
            record     = "job_type:billing_jobs_duration_seconds:99p5m"
            labels = {
              team = "dev"
            }
          }
          rule2 = {
            alert      = "Billing_Processing_Very_Slow"
            enabled    = true
            expression = <<EOF
            histogram_quantile(0.99, sum(rate(jobs_duration_seconds_bucket{service="billing-processing"}[5m])) by (job_type))
            EOF
            for        = "PT5M"
            severity   = 2

            action = {
              action_group_id = module.mag.groups.demo.id
            }

            alert_resolution = {
              auto_resolved   = true
              time_to_resolve = "PT10M"
            }

            annotations = {
              annotationName = "annotationValue"
            }

            labels = {
              team = "dev"
            }
          }
        }
      }
    }
  }
}
