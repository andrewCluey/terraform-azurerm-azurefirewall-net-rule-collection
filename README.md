# terraform-azurerm-azurefirewall-rules
Create Network Rules for an Azure Firewall


## Example deployment
This example deploys a new Azure firewall resource into an existing subnet (found using the Data Lookup resource) with 2 network rule collections. One rule collection deploys a set of ALLOWED rules and another rule collection for all DENY traffic.

Each rule collection requires 1 azurefirewall-net-rule-collection module to be called. 

A Rule collection can contain multiple related rules (for example all ALLOW or all DENY rules).

```
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
  version = "2.0.0"

  resource_group_name = "sazfw"
  subnet_id           = data.azurerm_subnet.azure_firewall.id
  environment         = "non-prod"

  tags = {
    DeployedBy = "Terraform"
  }
}

module "project_out_allow_net_rule" {
  source  = "andrewCluey/azurefirewall-net-rule-collection/azurerm"
  version = "1.4.1"

  azure_fw_name          = module.azfirewall.fw_name
  resource_group_name    = "CORE-FW-RG"
  rule_collection_name   = "dev_project_allow_rules"
  rule_priority          = "300"
  rule_action            = "Allow"

  rule = [
    {
      name                  = "ALLOW_https_out"
      description           = "All all internal hosts to access the Internet on port 443."
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["443"]
      destination_addresses = ["0.0.0.0/0"]
      protocols             = ["TCP"]
    },
    {
      name                  = "ALLOW_sftp_out"
      description           = "All the specified host to access the SFTP servers defined in the destination field."
      source_addresses      = ["10.1.1.33/8"]
      destination_ports     = ["22"]
      destination_addresses = ["8.8.8.8", "123.123.123.123"]
      protocols             = ["TCP"]
    }
  ]
}

module "project_out_deny_net_rule" {
  source  = "andrewCluey/azurefirewall-net-rule-collection/azurerm"
  version = "1.4.1"

  azure_fw_name          = module.azfirewall.fw_name
  resource_group_name = "CORE-FW-RG"
  rule_collection_name   = "dev_project_deny_rules"
  rule_priority          = "310"
  rule_action            = "Deny"

  rule = [
    {
      name                  = "deny_http_out"
      description           = "Deny all outgoing traffic using HTTP"
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["80"]
      destination_addresses = ["0.0.0.0/0"]
      protocols             = ["TCP"]
    },
    {
      name                  = "deny_ftp_out"
      description           = "Deny ALL internal hosts accessing FTP servers."
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["21"]
      destination_addresses = ["0.0.0.0/0"]
      protocols             = ["TCP"]
    }
  ]
}

```