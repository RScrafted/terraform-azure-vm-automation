#To delete the resources especially used with regular executation plan or destruction.
terraform plan -destroy -out="planout"   #Is there a file type to use? .tfplan??
terraform apply "planout"
#or terraform destroy