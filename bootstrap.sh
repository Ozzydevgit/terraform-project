#!/bin/bash


# ensure you have docker running
sudo yum update
sudo yum --skip-broken install docker unzip curl  -y
sudo service docker start
sudo usermod -a -G docker $(whoami)
newgrp docker


curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# login to ecr
sudo aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 767398043045.dkr.ecr.eu-west-1.amazonaws.com

# docker pull the image down from ecr
sudo docker run -d -p 3000:3000 767398043045.dkr.ecr.eu-west-1.amazonaws.com/wipro-test:latest

sudo docker run -d -p 8080:8080 767398043045.dkr.ecr.eu-west-1.amazonaws.com/wipro-test:jenkins

