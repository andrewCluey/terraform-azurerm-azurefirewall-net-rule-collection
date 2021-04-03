variable "rule_collection_name" {
  description = "(Required) Specifies the name of the Network Rule Collection which must be unique within the Firewall. Changing this forces a new resource to be created."
  type        = string
}

variable "azure_fw_name" {
  description = "(Required) Specifies the name of the Firewall in which the Network Rule Collection should be created. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group in which the Firewall exists. Changing this forces a new resource to be created."
  type        = string
}

variable "rule_priority" {
  description = "(Required) Specifies the priority of the rule collection. Possible values are between 100 - 65000."
  type        = string
}

variable "rule_action" {
  description = "(Required) Specifies the action the rule will apply to matching traffic. Possible values are Allow and Deny."
  type        = string
}

variable "rule" {
  description = "A list of rules to add to the new collection. See Readme.md for an example of how to format this input parameter."
}