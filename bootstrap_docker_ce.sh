#!/bin/sh

# Install Docker CE Ubuntu AMI

# set -e

curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
chmod +x /tmp/get-docker.sh
./get-docker.sh
sudo groupadd docker
sudo usermod -aG docker ubuntu

sudo systemctl enable docker
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.29.2/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker --version
