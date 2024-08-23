#!/bin/bash


# ensure you have docker running
sudo apt-get update
sudo apt-get install docker.io unzip curl  -y
sudo systemctl start docker
sudo usermod -a -G docker $(whoami)
newgrp docker


curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# login to ecr
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 767398043045.dkr.ecr.us-east-1.amazonaws.com

# docker pull the image down from ecr
docker run -d -p 3000:3000 767398043045.dkr.ecr.us-east-1.amazonaws.com/wipro:latest



