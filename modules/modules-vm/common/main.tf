# Configure the Azure provider
terraform {
  required_version = ">= 1.1.0"
}

resource "azurerm_network_security_rule" "RDPRule" {
  name                        = "${var.vm_name}-RDPrule"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = "${var.vm_name}-nsg"
  priority                    = 1000
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  destination_port_range      = 3389
  source_address_prefix       = var.restricted_ip
  source_port_range           = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_interface_security_group_association" "association_nic_common" {
  network_interface_id      = azurerm_network_interface.common_nic.id
  network_security_group_id = var.nsg_id
}

resource "azurerm_subnet_network_security_group_association" "association_subnet_common" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_interface_security_group_association.association_nic_common.network_security_group_id
}

resource "azurerm_public_ip" "common_public_ip" {
  allocation_method   = "Static"
  location            = var.azure_region
  name                = "${var.vm_name}-ip"
  resource_group_name = var.resource_group_name
  tags                = var.my_tags
}

resource "azurerm_network_interface" "common_nic" {
  location            = var.azure_region
  name                = "${var.vm_name}-nic"
  resource_group_name = var.resource_group_name
  tags                = var.my_tags
  ip_configuration {
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.common_public_ip.id
    name                          = "${var.vm_name}-nic-ipcfg"
  }
}

output "nic_id" {
  value = azurerm_network_interface.common_nic.id
}
