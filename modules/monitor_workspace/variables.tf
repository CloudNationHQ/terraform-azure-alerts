variable "workspace" {
  description = "Contains all azure monitor workspace settings"
  type = object({
    name                          = string
    resource_group_name           = optional(string, null)
    location                      = optional(string, null)
    public_network_access_enabled = optional(bool, true)
    tags                          = optional(map(string))
  })
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
