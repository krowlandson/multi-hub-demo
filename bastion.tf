resource "azurerm_public_ip" "hub_nonprod_bastion" {
  name                = "${azurerm_resource_group.hub_nonprod.name}-bastion-pip"
  location            = azurerm_resource_group.hub_nonprod.location
  resource_group_name = azurerm_resource_group.hub_nonprod.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "hub_nonprod_bastion" {
  name                = "${azurerm_resource_group.hub_nonprod.name}-bastion"
  location            = azurerm_resource_group.hub_nonprod.location
  resource_group_name = azurerm_resource_group.hub_nonprod.name
  sku                 = "Standard"
  ip_connect_enabled  = true

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub_nonprod_bastion.id
    public_ip_address_id = azurerm_public_ip.hub_nonprod_bastion.id
  }
}
