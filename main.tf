# Install terraform
#wget https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip
#unzip terraform_0.12.0_linux_amd64.zip
#sudo mv terraform /usr/bin/
#which terraform
#terraform init
#terraform plan
#terraform apply --auto-approve
#terraform destroy --auto-approve
#If multiple versions of Terraform: 
#sudo ln -s /usr/local/bin/terraform_0.12.0/terraform /usr/bin/terraform_0.12.0

terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "us-east-2"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

resource "aws_instance" "example" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id,aws_security_group.ssh.id]
  key_name = "aws-poc"
  
  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/home/ubuntu/"
  }

  /* user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF */
  user_data=  <<-EOF
              #!/bin/bash
              sudo groupadd docker
              sudo usermod -aG docker ubuntu
              sudo systemctl enable docker
              sudo curl -L --fail https://github.com/docker/compose/releases/download/1.29.2/run.sh -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              docker pull wordpress
              docker pull mysql:5.7
              EOF
  #docker pull jwilder/whoami    
  #docker run -d -p 8080:8000 --name whoami -t jwilder/whoami
  #docker pull wordpress
  #docker pull mysql:5.7
  #docker-compose -f /tmp/docker-compose.yml

  tags = {
    Name = "terraform-example"
  }

}

/* data "external" "whatismyip" {
  program = ["/bin/bash" , "${path.module}/whatismyip.sh"]
} */

resource "aws_security_group" "instance" {

  name = var.security_group_name1

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh" {

  name = var.security_group_name2

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["73.48.134.89/32"]
    #cidr_blocks = [format("%s/%s",data.external.whatismyip.result["internet_ip"],32)]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



variable "security_group_name1" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}

variable "security_group_name2" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-ssh"
}

variable "ami_id" {
  description = "The ami ID built by Packer"
  type        = string
  default     = "ami-0fd1b2413f2faede1"
}
output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}

