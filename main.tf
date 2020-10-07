#################################################################
# Create New Network Security Rules in an Existing Azure Firewall
#################################################################


resource "azurerm_firewall_network_rule_collection" "fw_net_rule" {
  name                = var.rule_collection_name
  azure_firewall_name = var.azure_fw_name
  resource_group_name = var.fw_resource_group_name
  priority            = var.rule_priority
  action              = var.rule_action

  dynamic "rule" {
    for_each = var.rule
    content {
      name                  = lookup(rule.value, "name", null)                  # string
      source_addresses      = lookup(rule.value, "name", null)                  # list ["10.0.0.0/16",]
      destination_ports     = lookup(rule.value, "destination_ports", null)     # list ["53",]
      destination_addresses = lookup(rule.value, "destination_addresses", null) # list ["8.8.8.8","8.8.4.4",]
      protocols             = lookup(rule.value, "protocols", null)             # list ["TCP","UDP",]
    }
  }
}
