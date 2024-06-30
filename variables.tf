variable "resource_group_name" {
  description = "The name of the resource group"
}

# Location variable is referenced in multiple resources. ADD New if I want resources to be provisioned in different regions.
# az account list-locations -o table to Get Azure Regions
variable "location" {
  description = "The Azure region in which resources will be provisioned"
}

variable "virtual_network_name" {
  description = "The name of the Virtual Network"
}

variable "subnet_name" {
  description = "The name of the Subnet"
}

variable "network_interface_name" {
  description = "The name of the network interface"
}

variable "ip_configuration_name" {
  description = "The name of the IP Configuration resource"
}

variable "virtual_machine_name" {
  description = "The name of the Virtual Machine"
}

variable "vm_size" {
  description = "The size of the Virtual Machine"
}

variable "storage_os_disk" {
  description = "The name of the Storage OS disk"
}

variable "computer_name" {
  description = "The HOSTNAME"
}

variable "admin_username" {
  description = "The admin username"
}

variable "admin_password" {
  description = "The admin password"
}
variable "tags" {
  type = map(string)
}