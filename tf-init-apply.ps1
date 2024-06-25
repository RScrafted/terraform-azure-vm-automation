terraform fmt
# az account list-locations -o table
az login

<# Set the desired subscription
az account set --subscription "YOUR_SUBSCRIPTION_ID_OR_NAME" #>

terraform init
terraform validate
# terraform plan
# terraform apply -auto-approve

# terraform plan
terraform plan -var-file="terraform.tfvars" -out='tfplan.out'
terraform apply -auto-approve tfplan.out

# Show resources from state file
terraform state list

# az group show --name autoazvm-test-rg
terraform show # includes output

# To visually see, use below and paste output to http://www.webgraphviz.com/?tab=map
# terraform graph
terraform graph > graph.dot # saves in the current repository for later view.

# (Optional) Clean up the Terraform plan file
Remove-Item -Path "./tfplan.out" -Force