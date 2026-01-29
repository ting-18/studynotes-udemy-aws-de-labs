# commands for terraform

bash\

Initialize Terraform
terraform init \

Preview the changes
terraform plan \

Apply the changes
terraform apply \

Clean up resources
terraform destroy

How to remove some resources?
method 1. In your .tf configuration file, simply delete or comment out the entire block defining the specific resource or service you want to destroy. --> then run terraform plan, terraform apply
method 2. terraform destroy -target=<RESOURCE_ADDRESS>