#!/bin/bash

# install updates
apt-get update -y

# install deps
apt-get remove -y docker docker-engine
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get update -y
apt-get install -y docker-ce

# Start Docker
service docker start

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
usermod -aG docker ec2-user


mkdir /opt/dask-worker && chown ec2-user /opt/dask-worker
mkdir /opt/thredds && chown ec2-user /opt/thredds
mkdir /opt/tomcat && chown ec2-user /opt/tomcat
echo "${compose_file}" > /opt/dask-worker/docker-compose.yml
cd /opt/dask-worker && /usr/local/bin/docker-compose up -d
echo "${catalog_file}" > /opt/thredds/catalog.xml
