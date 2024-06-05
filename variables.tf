variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "autoazvm-test-rg" # Skip this to received a prompt. Since I am automating, we keep!
}

# Location variable is referenced in multiple resources. ADD New if I want resources to be provisioned in different regions.
# az account list-locations -o table to Get Azure Regions
variable "location" {
  description = "The Azure region in which resources will be provisioned"
  type        = string
  default     = "eastus" # Avoid skiping defaults for Resource Group, manually entering incorrect destroys the existing RG and related resources if any.
}

variable "network_interface_name" {
  description = "The name of the network interface"
  type        = string
  default     = "autoazvm-test-rg-ni" # This is must since i cannot reference the resource's own name in its definition. Instead, I defined as a variable to specify the name. I could use static name alternatively in the main.tf
}

variable "vm_size" {
  description = "The size of the Virtual Machine"
  type        = string
  default     = "standard_ds1_v2"
}