## Project Overview

The **Terraform Azure VM Automation** project demonstrates how to automate the deployment of a virtual machine (VM) in Azure using Terraform. This project aims to showcase Infrastructure as Code (IaC) principles and how to manage cloud resources efficiently. The project includes automated deployment scripts, Terraform configuration files, and examples of outputs for easy management and scalability of Azure resources.

## Prerequisites

Before you begin, ensure you have the following installed:

1. **Terraform**: [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. **Azure CLI**: [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. **Git**: [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
4. **PowerShell**: Available by default on Windows; for other operating systems, download from [Microsoft](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell).

## Project Structure

```
terraform-azure-vm-automation/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── git-init-push.ps1
├── tf-init-apply.ps1
├── tf-destroy.ps1
├── LICENSE
├── .gitignore
└── README.md
```

## Terraform Configuration

### main.tf

This file contains the core configuration for provisioning resources in Azure. It includes the setup for the resource group, virtual network, subnet, network interface, and virtual machine.

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.105.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "autoazvm-test-rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Project     = "Automated Azure VM Deployment"
    Environment = "Test"
    Owner       = "Rachit"
  }
}

resource "azurerm_virtual_network" "autoazvm-test-rg-vnet" {
  name                = "${var.resource_group_name}-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "autoazvm-test-rg-subnet" {
  name                 = "${var.resource_group_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.autoazvm-test-rg-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "autoazvm-test-rg-ni" {
  name                = var.network_interface_name
  resource_group_name = var.resource_group_name
  location            = azurerm_resource_group.autoazvm-test-rg.location

  ip_configuration {
    name                          = "${var.network_interface_name}-internal"
    subnet_id                     = azurerm_subnet.autoazvm-test-rg-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "autoazvm-test-rg-vm" {
  name                  = "${var.resource_group_name}-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.autoazvm-test-rg-ni.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.resource_group_name}-osdisk"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_profile {
    computer_name  = "myUbuntu"
    admin_username = "avengers"
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/avengers/.ssh/authorized_keys"
      key_data = file(var.ssh_key_path)
    }
  }

  tags = {
    Project     = "Automated Azure VM Deployment"
    Environment = "Test"
    Owner       = "Rachit"
  }
}
```

### variables.tf

This file defines the variables used in the Terraform configuration, making it easy to customize the deployment by changing variable values.

```hcl
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "autoazvm-test-rg"
}

variable "location" {
  description = "The Azure region in which resources will be provisioned"
  type        = string
  default     = "eastus"
}

variable "network_interface_name" {
  description = "The name of the network interface"
  type        = string
  default     = "autoazvm-test-rg-ni"
}

variable "vm_size" {
  description = "The size of the Virtual Machine"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "admin_password" {
  description = "The admin password for the VM"
  type        = string
}

variable "ssh_key_path" {
  description = "The path to the SSH public key file"
  type        = string
}
```

### outputs.tf

This file defines the outputs of the Terraform configuration, providing useful information about the deployed resources.

```hcl
output "resource_group_name" {
  value = azurerm_resource_group.autoazvm-test-rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.autoazvm-test-rg-vnet.name
}

output "subnet_id" {
  value = azurerm_subnet.autoazvm-test-rg-subnet.id
}

output "network_interface_ids" {
  value = azurerm_network_interface.autoazvm-test-rg-ni.id
}

output "virtual_machine_name" {
  value = azurerm_virtual_machine.autoazvm-test-rg-vm.name
}
```

## PowerShell Scripts

### git-init-push.ps1

This script initializes a Git repository, adds a remote origin, commits changes, and pushes to the remote repository. The script works uninterrupted if the GitHub repository is already created and the script is updated accordingly.

```powershell
# Check if .git directory exists
$gitInitialized = Test-Path -Path ".git" -PathType Container

if (-not $gitInitialized) {
    # Git is not initialized, perform git init
    git init
}

# Check if remote 'origin' already exists
$remoteExists = git remote get-url origin 2>$null

if (-not $remoteExists) {
    # Remote 'origin' does not exist, add it
    git remote add origin https://github.com/yourusername/terraform-azure-vm-automation
}

# Add files and commit changes
git add .
$commitMessage = Read-Host -Prompt 'Enter commit message'
git commit -m "$commitMessage"

# Push changes to remote 'origin'
git push
```

### tf-init-apply.ps1

This script initializes Terraform, validates the configuration, plans the deployment, and applies the changes. In addition, it takes a backup of the .tfstate and tfplan with an opportunity to creat the Graph.

```powershell
terraform fmt
az login

<# Set the desired subscription
az account set --subscription "YOUR_SUBSCRIPTION_ID_OR_NAME" #>

terraform init
terraform validate

terraform plan -out='tfplan.out'
terraform apply -auto-approve tfplan.out

terraform state list
terraform show
terraform graph > graph.dot
```

### tf-destroy.ps1

This script destroys the Terraform-managed infrastructure. Except NetworkWatcherRG, please refer my Key Learnings [here](https://github.com/RScrafted/terraform-azure-vm-automation?tab=readme-ov-file#key-learnings)

```powershell
terraform plan -destroy -out="planout"
terraform apply "planout"
```

## Key Learnings

- **network_interface_name**: I encountered issues when trying to reference a map {} directly. I resolved this by creating a separate variable.
- **network_interface_ids**: This parameter expects a list of strings. I addressed this by using square brackets [].
- **azurerm_virtual_network**: The virtual network resource was being prioritized before the resource group creation, causing failures. I fixed this by adding a `depends_on` clause to ensure it waits for the resource group.
- **NetworkWatcherRG**: Upon successful deployment, a new resource group named NetworkWatcherRG is automatically created as part of Azure's network monitoring service, which is currently free. This occurs because the configuration includes networking components such as VNET, SUBNET, and NI. This new resource group can be manually deleted or disabled for the deployed resource's region. [Reference](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-create?tabs=portal).

## Potential Enhancements

1. **Disable Password Authentication**: Update the `os_profile_linux_config` to `disable_password_authentication = true` for better security and configure SSH keys for VM access.
2. **Secret Management**: Move sensitive information such as admin passwords to a secure secret management system like Azure Key Vault.
3. **Scalability**: Enhance the configuration to support deployment of multiple VMs and additional Azure resources such as databases and load balancers.

## Contributing

Feel free to fork this repository and submit pull requests. For major changes, please open an issue first to discuss what you would like to change. I have started a discussion, and everyone can bring ideas there.

## Acknowledgments

Thanks to the Terraform and Azure documentation teams for their extensive resources and examples. This project was inspired by the need to automate and efficiently manage cloud infrastructure.
