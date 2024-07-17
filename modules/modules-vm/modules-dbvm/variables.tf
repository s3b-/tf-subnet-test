variable "azure_region" {
  type        = string
  description = "Defines the azure region the resource is in."
}
variable "name_prefix" {
  type        = string
  description = "Defines the name prefix of the resource."
}
variable "resource_group_name" {
  type        = string
  description = "Defines the name of the resource group."
}
variable "restricted_ip" {
  type        = string
  description = "Defines static IP address."
}
variable "subnet_id" {
  type        = string
  description = "Defines the subnet id."
}
variable "vm_name" {
  type        = string
  description = "The VM name."
}
variable "vm_size" {
  type        = string
  description = "Size of the VM."
}
variable "my_tags" {
  type        = map(string)
  description = "additional tags for deployment"
}
