# Monitoring Workspace

This submodule demonstrates how to manage a monitoring workspace.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9.3)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_monitor_workspace.ws](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_workspace) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_workspace"></a> [workspace](#input\_workspace)

Description: Contains all azure monitor workspace settings

Type:

```hcl
object({
    name                          = string
    resource_group_name           = optional(string, null)
    location                      = optional(string, null)
    public_network_access_enabled = optional(bool, true)
    tags                          = optional(map(string))
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_workspace"></a> [workspace](#output\_workspace)

Description: contains all azure monitor workspace settings
<!-- END_TF_DOCS -->
