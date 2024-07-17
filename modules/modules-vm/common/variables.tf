variable "azure_region" {
  type        = string
  description = "Defines the azure region the resource is in."
}

variable "resource_group_name" {
  type        = string
  description = "Defines the name of the resource group."
}
variable "restricted_ip" {
  type        = string
  description = "Defines static IP address."
}

variable "nsg_id" {
  type        = string
  description = "ID of network security group."
}

variable "vm_name" {
  type        = string
  description = "Name of the VM."
}

variable "subnet_id" {
  type        = string
  description = "Defines the subnet id."
}

variable "my_tags" {
  type        = map(string)
  description = "additional tags for deployment"
}
