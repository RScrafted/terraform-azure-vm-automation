## Terraform Azure Virtual Machine Automation

---

Provisioning Virtual Machine and related resources in Azure Platform using Terraform as IaC tool to deploy it.

- The `terraform.yml` automates the terraform initialize, validate, plan and apply stages to provision resources as stated in `main.tf`.

- The `tf-destroys.ps1` automates deprovisioning of the resources.

- The `terraform.tfvars` allows setup for multiple environments.

- The `backend.ps1` has pwsh commands to create the **remote backend** for terraform statefile.

---

## Architecture

![](.github/images/architecture.png)

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