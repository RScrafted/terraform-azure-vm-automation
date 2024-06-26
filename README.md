# Automated Azure Virtual Machine Deployment using Terraform

---

## Project Overview

The **Terraform Azure VM Automation** project demonstrates how to automate the deployment of a virtual machine (VM) in Azure using Terraform. I aim to showcase Infrastructure as Code (IaC) principles and how to manage cloud resources efficiently. This configuration includes automated deployment scripts for now, Terraform configuration files, and examples of outputs for easy management and scalability of Azure resources.

---

## Prerequisites

Before using the Terraform configuration, ensure the following is installed:

1. **Terraform**: [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. **Azure CLI**: [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. **Git**: [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
4. **PowerShell**: Available by default on Windows; for other operating systems, download from [Microsoft](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell).

### If you're new to Git, check out my [Git guide](https://github.com/RScrafted/guide-how-to-git/tree/main). Visual Studio Code makes it easy to get started.

---

## Structure

```
terraform-azure-vm-automation/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── git-init-push.ps1
├── tf-init-apply.ps1
├── tf-destroy.ps1
├── LICENSE
├── .gitignore
├── photos
│   ├── social_preview.jpg
│   ├── graph.png
│   ├── NetworkWatcherRG.png
└── README.md
```

---

## Terraform Configuration

### main.tf

This file contains the core configuration for provisioning resources in Azure. It includes the setup for the resource group, virtual network, subnet, network interface, and virtual machine.


### variables.tf

This file defines the variables used in the Terraform configuration and uses `terraform.tfvars` to specify values, making it easy to customize the deployment environment by changing variable values.


### outputs.tf

This file defines the outputs of the Terraform configuration, providing useful information about the deployed resources.


---

## PowerShell Scripts

### git-init-push.ps1

This script initializes a Git repository, adds a remote origin, commits changes, and pushes to the remote repository. The script works uninterrupted if the GitHub repository is already created and the script is updated accordingly.

Please refer my custom crafted [how to git guide](https://github.com/RScrafted/guide-how-to-git) if you are a beginner.


### tf-init-apply.ps1

This script initializes Terraform, validates the configuration, plans the deployment, and applies the changes. In addition, it takes a backup of the .tfstate and tfplan with an opportunity to creat the Graph.


### tf-destroy.ps1

This script destroys the Terraform-managed infrastructure. Except NetworkWatcherRG, please refer my Key Learnings [here](https://github.com/RScrafted/terraform-azure-vm-automation?tab=readme-ov-file#key-learnings)


---

## Graph Output

![Graph Output](https://github.com/RScrafted/terraform-azure-vm-automation/blob/549f1271d5ecfc20c706c64c163d9655cd8d48ef/photos/graph.png)

---

## Key Learnings

Please visit the [WIKI](https://github.com/RScrafted/terraform-azure-vm-automation/wiki) page.


---

## Potential Enhancements (in progress)

1. **Disable Password Authentication**: Update the `os_profile_linux_config` to `disable_password_authentication = true` for better security and configure SSH keys for VM access.
2. **Secret Management**: Move sensitive information such as admin passwords to a secure secret management system like Azure Key Vault.
3. **Scalability**: Enhance the configuration to support deployment of multiple VMs and additional Azure resources such as databases and load balancers.
4. **Load Balancer** and **CI/CD Integration**


---

## Contributing

Feel free to fork this repository and submit pull requests. For major changes, please open an issue first to discuss what you would like to change. I have started a discussion, and everyone can bring ideas there.

---

## Acknowledgments

Thanks to the Terraform and Azure documentation teams for their extensive resources and examples. This project was inspired from my previous role as IT Administrator and the need to automate and efficiently manage cloud infrastructure.

---