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
      name                  = rule.value.name                                   # string
      source_addresses      = rule.value.source_addresses                       # list ["10.0.0.0/16",]
      source_ip_groups      = lookup(rule.value, "source_ip_groups", null)      # list
      destination_ports     = rule.value.destination_ports                      # list ["53",]
      destination_fqdns     = lookup(rule.value, "destination_fqdns", null)     # list
      destination_ip_groups = lookup(rule.value, "destination_ip_groups", null) # list
      destination_addresses = rule.value.destination_addresses                  # list ["8.8.8.8","8.8.4.4",]
      protocols             = rule.value.protocols                              # list ["TCP","UDP",]
    }
  }
}