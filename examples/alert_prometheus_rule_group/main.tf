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
      location = "northeurope"
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

module "mw" {
  source = "../../modules/azure_monitor_workspace"

  workspace = {
    name           = "mw-demo"
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 2.0"

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}

module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 3.1"

  keyvault = module.kv.vault.id

  cluster = {
    name           = module.naming.kubernetes_cluster.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    depends_on     = [module.kv]
    profile        = "linux"
    dns_prefix     = "demo"

    identity = {
      type = "SystemAssigned"
    }

    default_node_pool = {
      name       = "default"
      node_count = 1
      # zones      = [3]
      vm_size = "standard_d2_v5"
    }
  }
}

module "alerts" {
  source = "../../"

  config = {
    alert_prometheus_rule_groups = {
      aprg1 = {
        name               = "aprg1"
        location           = module.rg.groups.demo.location
        resource_group     = module.rg.groups.demo.name
        cluster_name       = module.aks.cluster.name
        rule_group_enabled = false
        interval           = "PT1M"
        scopes             = [module.mw.workspace.id]
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
