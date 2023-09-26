# Virtual machines for connectivity testing

module "virtual_machines" {
  source = "./modules/vm_windows_server_2016"
  for_each = {
    # The following keys will be used to set the VM name and must not exceed 15 characters long
    n-h-rras-vm001 = {
      resource_group_name  = azurerm_resource_group.hub_nonprod.name
      subnet_id            = azurerm_subnet.hub_nonprod_nva.id
      script_path          = "${path.root}/scripts/install_rras.ps1"
      enable_ip_forwarding = true
    }
    i-h-rras-vm001 = {
      resource_group_name  = azurerm_resource_group.hub_internet.name
      subnet_id            = azurerm_subnet.hub_internet_nva.id
      script_path          = "${path.root}/scripts/install_rras.ps1"
      enable_ip_forwarding = true
    }
    m-h-rras-vm001 = {
      resource_group_name  = azurerm_resource_group.hub_management.name
      subnet_id            = azurerm_subnet.hub_management_nva.id
      script_path          = "${path.root}/scripts/install_rras.ps1"
      enable_ip_forwarding = true
    }
    r-h-test-vm001 = {
      resource_group_name = azurerm_resource_group.hub_ars.name
      subnet_id           = azurerm_subnet.hub_ars_default.id
      script_path         = "${path.root}/scripts/enable_icmp.ps1"
    }
    n-h-test-vm001 = {
      resource_group_name = azurerm_resource_group.hub_nonprod.name
      subnet_id           = azurerm_subnet.hub_nonprod_default.id
      script_path         = "${path.root}/scripts/enable_icmp.ps1"
    }
    i-h-test-vm001 = {
      resource_group_name = azurerm_resource_group.hub_internet.name
      subnet_id           = azurerm_subnet.hub_internet_default.id
      script_path         = "${path.root}/scripts/enable_icmp.ps1"
    }
    m-h-test-vm001 = {
      resource_group_name = azurerm_resource_group.hub_management.name
      subnet_id           = azurerm_subnet.hub_management_default.id
      script_path         = "${path.root}/scripts/enable_icmp.ps1"
    }
    n-s-test-vm001 = {
      resource_group_name = azurerm_resource_group.spoke_nonprod_001.name
      subnet_id           = azurerm_subnet.spoke_nonprod_001_default.id
      script_path         = "${path.root}/scripts/enable_icmp.ps1"
    }
    n-s-test-vm002 = {
      resource_group_name = azurerm_resource_group.spoke_nonprod_002.name
      subnet_id           = azurerm_subnet.spoke_nonprod_002_default.id
      script_path         = "${path.root}/scripts/enable_icmp.ps1"
    }
    n-s-test-vm003 = {
      resource_group_name = azurerm_resource_group.spoke_nonprod_003.name
      subnet_id           = azurerm_subnet.spoke_nonprod_003_default.id
      script_path         = "${path.root}/scripts/enable_icmp.ps1"
    }
    m-s-test-vm001 = {
      resource_group_name = azurerm_resource_group.spoke_management.name
      subnet_id           = azurerm_subnet.spoke_management_default.id
      script_path         = "${path.root}/scripts/enable_icmp.ps1"
    }
    n-dc-test-vm001 = {
      resource_group_name = azurerm_resource_group.onprem_dc1_nonprod.name
      subnet_id           = azurerm_subnet.onprem_dc1_nonprod_default.id
      script_path         = "${path.root}/scripts/enable_icmp.ps1"
    }
    m-dc-test-vm001 = {
      resource_group_name = azurerm_resource_group.onprem_dc1_management.name
      subnet_id           = azurerm_subnet.onprem_dc1_management_default.id
      script_path         = "${path.root}/scripts/enable_icmp.ps1"
    }
  }

  name                 = each.key
  location             = var.location
  resource_group_name  = each.value.resource_group_name
  subnet_id            = each.value.subnet_id
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  script_path          = each.value.script_path
  enable_ip_forwarding = lookup(each.value, "enable_ip_forwarding", false)

}
