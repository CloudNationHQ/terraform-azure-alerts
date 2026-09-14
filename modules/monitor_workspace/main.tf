resource "azurerm_monitor_workspace" "this" {

  resource_group_name = coalesce(
    var.workspace.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.workspace.location, var.location
  )

  name                          = var.workspace.name
  public_network_access_enabled = var.workspace.public_network_access_enabled

  tags = coalesce(
    var.workspace.tags, var.tags
  )
}
