# login to the azure portal
az login

# create RG
az group create --name tfstate-bkp-rg --location eastus

# create storage account | Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.
az storage account create --name tfstatebkp --location eastus --resource-group tfstate-bkp-rg

# get storage account key - need account key, so below command will put it in the $ACCOUNT_KEY variable
$ACCOUNT_KEY = az storage account keys list --resource-group tfstate-bkp-rg --account-name tfstatebkp --query '[0].value' -o tsv

# create  a container - because it will have tfstate files and public access is set to off for restrict unauthorized access.
az storage container create --account-name tfstatebkp --name tfstate --public-access off --account-key $ACCOUNT_KEY