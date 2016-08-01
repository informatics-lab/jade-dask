#!/bin/bash

# install docker
curl -sSL https://get.docker.com/ | sh

# Start Docker
service docker start

# Install Docker Compose
curl -L https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
usermod -aG docker ec2-user

# get keys
s3get jade-secrets/jade-secrets

# get config
git clone https://github.com/met-office-lab/jade.git

# run config
docker-compose up -d -f jade/docker/master
