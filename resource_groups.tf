resource "azurerm_resource_group" "hub_ars" {
  name     = "hub_ars"
  location = var.location
}

resource "azurerm_resource_group" "hub_nonprod" {
  name     = "hub_nonprod"
  location = var.location
}

resource "azurerm_resource_group" "hub_internet" {
  name     = "hub_internet"
  location = var.location
}

resource "azurerm_resource_group" "hub_management" {
  name     = "hub_management"
  location = var.location
}

resource "azurerm_resource_group" "spoke_nonprod_001" {
  name     = "spoke_nonprod_001"
  location = var.location
}

resource "azurerm_resource_group" "spoke_nonprod_002" {
  name     = "spoke_nonprod_002"
  location = var.location
}

resource "azurerm_resource_group" "spoke_nonprod_003" {
  name     = "spoke_nonprod_003"
  location = var.location
}

resource "azurerm_resource_group" "spoke_management" {
  name     = "spoke_management"
  location = var.location
}

resource "azurerm_resource_group" "onprem_dc1_nonprod" {
  name     = "onprem_dc1_nonprod"
  location = var.location
}

resource "azurerm_resource_group" "onprem_dc1_management" {
  name     = "onprem_dc1_management"
  location = var.location
}
