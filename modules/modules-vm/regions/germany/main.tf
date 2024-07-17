# Configure the Azure provider
terraform {
  required_version = ">= 1.1.0"
}

resource "azurerm_resource_group" "rg_germany" {
  location = var.azure_region
  name     = var.resource_group_name
  tags     = var.my_tags
}

resource "azurerm_virtual_network" "VNET" {
  address_space       = [var.address_space]
  location            = var.azure_region
  name                = "${var.name_prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg_germany.name
  tags                = var.my_tags
}

resource "azurerm_subnet" "subnet_germany" {
  name                 = "${var.name_prefix}-subnet"
  address_prefixes     = [var.address_space]
  resource_group_name  = azurerm_virtual_network.VNET.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNET.name
}

# App servers
module "german_appserver_01" {
  source              = "../../modules-appvm"
  azure_region        = var.azure_region
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.rg_germany.name
  restricted_ip       = var.restricted_ip
  subnet_id           = azurerm_subnet.subnet_germany.id
  vm_name             = "${var.vm_name_prefix}-APP-01"
  vm_size             = "Standard_B2ms"
  my_tags             = var.my_tags
}

# DB servers
module "german_dbserver_01" {
  source              = "../../modules-dbvm"
  azure_region        = var.azure_region
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.rg_germany.name
  restricted_ip       = var.restricted_ip
  subnet_id           = azurerm_subnet.subnet_germany.id
  vm_name             = "${var.vm_name_prefix}-DB-01"
  vm_size             = "Standard_B2ms"
  my_tags             = var.my_tags
}
