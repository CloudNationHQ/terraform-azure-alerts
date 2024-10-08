resource "azurerm_monitor_workspace" "ws" {
  name                          = var.workspace.name
  resource_group_name           = coalesce(lookup(var.workspace, "resource_group", null), var.resource_group)
  location                      = coalesce(lookup(var.workspace, "location", null), var.location)
  public_network_access_enabled = try(var.workspace.public_network_access_enabled, true)
  tags                          = try(var.workspace.tags, var.tags)
}