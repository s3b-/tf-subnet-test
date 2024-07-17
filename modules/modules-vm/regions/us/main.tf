# Configure the Azure provider
terraform {
  required_version = ">= 1.1.0"
}

resource "azurerm_resource_group" "rg_unitedstates" {
  location = var.azure_region
  name     = var.resource_group_name
}

resource "azurerm_virtual_network" "VNET" {
  address_space       = [var.address_space]
  location            = var.azure_region
  name                = "${var.name_prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg_unitedstates.name
  tags                = var.my_tags
}

resource "azurerm_subnet" "subnet_unitedstates" {
  name                 = "${var.name_prefix}-subnet"
  address_prefixes     = [var.address_space]
  resource_group_name  = azurerm_virtual_network.VNET.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNET.name
}

# App servers
module "us_appserver_01" {
  source              = "../../modules-appvm"
  azure_region        = var.azure_region
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.rg_unitedstates.name
  restricted_ip       = var.restricted_ip
  subnet_id           = azurerm_subnet.subnet_unitedstates.id
  vm_name             = "${var.vm_name_prefix}-APP-01"
  vm_size             = "Standard_B2ms"
  my_tags             = var.my_tags
}
