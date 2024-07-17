# Configure the Azure provider
terraform {
  required_version = ">= 1.1.0"
}

module "common" {
  source              = "../common"
  azure_region        = var.azure_region
  resource_group_name = azurerm_network_security_group.db_server.resource_group_name
  restricted_ip       = var.restricted_ip
  nsg_id              = azurerm_network_security_group.db_server.id
  vm_name             = var.vm_name
  subnet_id           = var.subnet_id
  my_tags             = var.my_tags
}

resource "azurerm_network_security_group" "db_server" {
  name                = "${var.vm_name}-nsg"
  location            = var.azure_region
  resource_group_name = var.resource_group_name
  tags                = var.my_tags
}

resource "azurerm_virtual_machine" "db_server" {
  location = var.azure_region
  name     = var.vm_name
  network_interface_ids = [
    module.common.nic_id
  ]
  resource_group_name = var.resource_group_name
  vm_size             = var.vm_size
  tags                = var.my_tags
  storage_os_disk {
    name              = "${var.vm_name}-systemdisk"
    caching           = "ReadWrite"
    managed_disk_type = "StandardSSD_LRS"
    os_type           = "Windows"
    disk_size_gb      = 128
    create_option     = "FromImage"
  }

  storage_image_reference {
    offer     = "sql2022-ws2022"
    publisher = "MicrosoftSQLServer"
    sku       = "web-gen2"
    version   = "latest"
  }

  os_profile {
    admin_password = random_password.password.result
    admin_username = "adminadmin"
    computer_name  = var.vm_name
  }

  storage_data_disk {
    create_option     = "Empty"
    lun               = 0
    name              = "${var.vm_name}-datadisk-1"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 128
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
}

resource "azurerm_mssql_virtual_machine" "db_server" {
  virtual_machine_id               = azurerm_virtual_machine.db_server.id
  sql_license_type                 = "PAYG"
  r_services_enabled               = false
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_password = random_password.password.result
  sql_connectivity_update_username = "adminadmin"
  tags                             = var.my_tags
  auto_patching {
    day_of_week                            = "Sunday"
    maintenance_window_duration_in_minutes = 60
    maintenance_window_starting_hour       = 2
  }

  storage_configuration {
    disk_type                      = "NEW"
    storage_workload_type          = "GENERAL"
    system_db_on_data_disk_enabled = true

    data_settings {
      default_file_path = "G:\\Data"
      luns              = [0]
    }

    log_settings {
      default_file_path = "G:\\LOG"
      luns              = [0]
    }
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}