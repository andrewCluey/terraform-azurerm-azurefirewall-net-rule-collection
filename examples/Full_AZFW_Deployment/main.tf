provider "azurerm" {
  features {}
}

data "azurerm_subnet" "azure_firewall" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = "core-vnet"
  resource_group_name  = "network"
}

module "azfirewall" {
  source  = "andrewCluey/azfirewall/azurerm"
  version = "1.3.2"
  
  resource_group_name = "sazfw"
  subnet_id           = data.azurerm_subnet.azure_firewall.id
  environment         = "non-prod"

    tags = {
    DeployedBy = "Terraform"
  }
}

module "project_out_allow_net_rule" {
  source  = "andrewCluey/azurefirewall-net-rule-collection/azurerm"
  version = "1.3.0"

  azure_fw_name           = module.azfirewall.fw_name
  fw_resource_group_name  = "CORE-FW-RG"
  rule_collection_name    = "dev_project_allow_rules"
  rule_priority           = "300"
  rule_action             = "Allow"
  
  rule = [
    {
      name                  = "ALLOW_https_out"
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["443"]
      destination_addresses = ["0.0.0.0/0"]
      protocols             = ["TCP"]
    },
    {
      name                  = "ALLOW_sftp_out"
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["22"]
      destination_addresses = ["8.8.8.8"]
      protocols             = ["TCP"]
    }
  ]
}

module "project_out_deny_net_rule" {
  source  = "andrewCluey/azurefirewall-net-rule-collection/azurerm"
  version = "1.3.0"

  azure_fw_name           = module.azfirewall.fw_name
  fw_resource_group_name  = "CORE-FW-RG"
  rule_collection_name    = "dev_project_deny_rules"
  rule_priority           = "310"
  rule_action             = "Deny"
  
  rule = [
    {
      name                  = "deny_http_out"
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["80"]
      destination_addresses = ["0.0.0.0/0"]
      protocols             = ["TCP"]
    },
    {
      name                  = "deny_ftp_out"
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["21x"]
      destination_addresses = ["8.8.8.8"]
      protocols             = ["TCP"]
    }
  ]
}


# "git::ssh://git@ssh.dev.azure.com/v3/AzDoOrgName/projectName/terraform-azurerm-ModuleName"