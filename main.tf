# Configure Terraform to set the required AzureRM provider
# version and features{} block

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.65.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

# Define the provider configuration

provider "azurerm" {
  features {}

  subscription_id = "eecca634-8cff-42d8-bf2a-385144ab1637"
}

# Get the current client configuration from the AzureRM provider

data "azurerm_client_config" "current" {}

# Consolidate config for all virtual networks created by the module for easy cross-reference

locals {
  azurerm_virtual_network_config = {
    onprem_dc1_nonprod    = azurerm_virtual_network.onprem_dc1_nonprod
    onprem_dc1_management = azurerm_virtual_network.onprem_dc1_management
    hub_nonprod_ars       = azurerm_virtual_network.hub_nonprod_ars
    hub_nonprod           = azurerm_virtual_network.hub_nonprod
    hub_internet          = azurerm_virtual_network.hub_internet
    hub_management        = azurerm_virtual_network.hub_management
    spoke_nonprod_001     = azurerm_virtual_network.spoke_nonprod_001
    spoke_nonprod_002     = azurerm_virtual_network.spoke_nonprod_002
    spoke_nonprod_003     = azurerm_virtual_network.spoke_nonprod_003
    spoke_management      = azurerm_virtual_network.spoke_management
  }
}

# Consolidate config for all subnets created by the module for easy cross-reference

locals {
  azurerm_subnet_config = {
    hub_nonprod_gateway       = azurerm_subnet.hub_nonprod_gateway,
    hub_management_gateway    = azurerm_subnet.hub_management_gateway,
    spoke_nonprod_001_default = azurerm_subnet.spoke_nonprod_001_default,
    spoke_nonprod_002_default = azurerm_subnet.spoke_nonprod_002_default,
    spoke_nonprod_003_default = azurerm_subnet.spoke_nonprod_003_default,
    spoke_management_default  = azurerm_subnet.spoke_management_default,
  }
}
