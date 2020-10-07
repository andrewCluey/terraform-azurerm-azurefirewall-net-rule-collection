variable "name" {
  description = "description"
  type        = string
}

variable "azure_fw_name" {
  description = "description"
  type        = string
}

variable "fw_resource_group_name" {
  description = "description"
  type        = string
}

variable "rule_priority" {
  description = "description"
  type        = string
}

variable "rule_action" {
  description = "description"
  type        = string
}

variable "rule" {
  description = "A list of rules to add to the new collection. See Readme.md for an example of how to format this input parameter."
}

