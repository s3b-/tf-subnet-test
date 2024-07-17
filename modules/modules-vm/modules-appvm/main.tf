# Configure the Azure provider
terraform {
  required_version = ">= 1.1.0"
}


module "common" {
  source              = "../common"
  azure_region        = var.azure_region
  resource_group_name = azurerm_network_security_group.app_server_nsg.resource_group_name
  restricted_ip       = var.restricted_ip
  nsg_id              = azurerm_network_security_group.app_server_nsg.id
  vm_name             = var.vm_name
  subnet_id           = var.subnet_id
  my_tags             = var.my_tags
}

resource "azurerm_network_security_group" "app_server_nsg" {
  name                = "${var.vm_name}-nsg"
  location            = var.azure_region
  resource_group_name = var.resource_group_name
  tags                = var.my_tags
}

resource "azurerm_windows_virtual_machine" "app_server" {
  admin_password = random_password.password.result
  admin_username = "adminadmin"
  location       = var.azure_region
  name           = var.vm_name
  network_interface_ids = [
    module.common.nic_id
  ]
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  tags                = var.my_tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}


