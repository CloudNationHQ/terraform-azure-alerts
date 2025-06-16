resource "azurerm_monitor_workspace" "ws" {

  resource_group_name = coalesce(
    lookup(
      var.workspace, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.workspace, "location", null
    ), var.location
  )

  name                          = var.workspace.name
  public_network_access_enabled = var.workspace.public_network_access_enabled

  tags = coalesce(
    var.workspace.tags, var.tags
  )
}
