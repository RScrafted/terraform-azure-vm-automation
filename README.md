## Terraform Azure Virtual Machine Automation

---

Provisioning Virtual Machine and related resources in Azure Platform using Terraform as IaC tool to deploy it.

- The `terraform.yml` automates Continuous Integration (CI) executing terraform initialize, validate, plan, and performs Continuous Dilivery (CD) that executes terraform apply to provision resources as stated in `main.tf`.

- The `workflow_dispatch.yml` allows manual trigger towards deprovisioning of the resources for cost effectiveness.

- The `terraform.tfvars` allows setup for multiple environments.

- The `backend` configuration creates new Resource Group to avoid saving on runner's machine, enhancing security and effective team collaboration.

Note: It is important to Create TFState Backup Resource Group Prior to allow Terraform to initialize backend configuration.

---

## Architecture

![](images/architecture.png)

---

### Key Learnings

Please visit the [WIKI](https://github.com/RScrafted/terraform-azure-vm-automation/wiki) page.

---

### Acknowledgements
- [Terraform Documentation](https://www.terraform.io/docs/providers/azurerm/)
- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)
- **PowerShell**: PowerShell file used to centralize terraform commands related to this project.
- **GitHub**: Platform for version control and collaboration.
- `backend.ps1` - Reference: [Microsoft Reactor Series](https://developer.microsoft.com/en-us/reactor/series/S-1162/)

---