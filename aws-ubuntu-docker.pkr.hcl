##INSTRUCTIONS TO INSTALL PACKER ##############
#export AWS_ACCESS_KEY_ID=XXX
#export AWS_SECRET_ACCESS_KEY=xxx
#sudo apt-get update && sudo apt-get install packer
## EXECUTE THE COMMANDS
#packer init .
#packer fmt .
#packer validate .
#packer build docker-ubuntu.pkr.hcl
###############################################

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws-docker"
  instance_type = "t2.medium"
  region        = "us-east-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  vpc_id       = "vpc-32d56f59"
  security_group_id = "sg-07d81e788234bfa40"

}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "bootstrap_docker_ce.sh"
    destination = "/tmp/bootstrap_docker_ce.sh"
  }

  provisioner "file" {
    source      = "cleanup.sh"
    destination = "/tmp/cleanup.sh"
  }

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "whoami",
      "cd /tmp",
      "chmod +x /tmp/bootstrap_docker_ce.sh",
      "chmod +x /tmp/cleanup.sh",
      "ls -alh /tmp",
      "./bootstrap_docker_ce.sh",
      "sleep 10",
      "./cleanup.sh"
    ]
  }



}
