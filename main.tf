# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.78.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}


module "german_module" {
  source              = "./modules/modules-vm/regions/germany"
  azure_region        = "germanywestcentral"
  name_prefix         = "subnet-test-de"
  resource_group_name = "rg-subnet-test-de"
  restricted_ip       = "192.168.0.1"
  vm_name_prefix      = "DE"
  my_tags = {
    source     = "terraform"
    department = "subnet-test"
    region     = "de"
  }
  address_space = "10.100.2.0/24"
}

# module "us_module" {
#   source              = "./modules/modules-vm/regions/us"
#   azure_region        = "eastus"
#   name_prefix         = "subnet-test-us"
#   resource_group_name = "rg-subnet-test-us"
#   restricted_ip = "192.168.0.1"
#   vm_name_prefix = "DE"
#   my_tags = {
#     source     = "terraform"
#     department = "subnet-test"
#     region     = "us"
#   }
#   address_space = "10.100.3.0/24"
# }