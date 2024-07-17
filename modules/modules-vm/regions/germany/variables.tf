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
variable "vm_name_prefix" {
  type        = string
  description = "Prefix for the VM name."
}
variable "my_tags" {
  type        = map(string)
  description = "additional tags for deployment"
}
variable "address_space" {
  type        = string
  description = "IP address space"
}