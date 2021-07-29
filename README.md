
## INSTRUCTIONS TO INSTALL PACKER ##############
* install aws cli
* https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install

* #export AWS_ACCESS_KEY_ID=XXX
* #export AWS_SECRET_ACCESS_KEY=xxx
* #sudo apt-get update && sudo apt-get install packer
* replace "sg-YOUR-SECURITY-GROUP" WITH YOUR SECURITY GROUP
* Make sure security group has ssh access from your IP address
```
source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws-docker"
  ...
  security_group_id = "sg-YOUR-SECURITY-GROUP"

}
```

* ## EXECUTE THE COMMANDS
* #packer init .
* #packer fmt .
* #packer validate .
* #packer build docker-ubuntu.pkr.hcl
* ###############################################

## Install terraform
* #wget https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip
* #unzip terraform_0.12.0_linux_amd64.zip
* #sudo mv terraform /usr/bin/
* #which terraform
* in main.tf, change security group IP address to your own IP
```
resource "aws_security_group" "ssh" {

  name = var.security_group_name2

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["YOUR-IP-ADDRESS/32"]
    #cidr_blocks = [format("%s/%s",data.external.whatismyip.result["internet_ip"],32)]

  }
```
* #terraform init
* #terraform plan
* #terraform apply --auto-approve
* #terraform destroy --auto-approve
* #If multiple versions of Terraform: 
* #sudo ln -s /usr/local/bin/terraform_0.12.0/terraform /usr/bin/terraform_0.12.0

### The Problem: 
* Benchmarking an App (example: Wordpress) on 1000s of instances requires installing the same software repeatedly. 
### The Solution: 
* Create pre-installed AMI Images that already have the software pre-installed on instance boot. Using Packer

### The Problem: 
* Manual install of apps error prone, not easily repeatable, especially when Infrastructure also needs to be repeatable.
### The SOlution:
* Use Terraform to automate/ repeatable infrastructure, use Docker to automate software install, easily repeatable.