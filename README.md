
## INSTRUCTIONS TO INSTALL PACKER ##############
** #export AWS_ACCESS_KEY_ID=XXX
** #export AWS_SECRET_ACCESS_KEY=xxx
** #sudo apt-get update && sudo apt-get install packer
** ## EXECUTE THE COMMANDS
** #packer init .
** #packer fmt .
** #packer validate .
** #packer build docker-ubuntu.pkr.hcl
** ###############################################

## Install terraform
** #wget https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip
** #unzip terraform_0.12.0_linux_amd64.zip
** #sudo mv terraform /usr/bin/
** #which terraform
** #terraform init
** #terraform plan
** #terraform apply --auto-approve
** #terraform destroy --auto-approve
** #If multiple versions of Terraform: 
** #sudo ln -s /usr/local/bin/terraform_0.12.0/terraform /usr/bin/terraform_0.12.0

