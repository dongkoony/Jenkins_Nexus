#!/bin/bash

# Install Docker
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add current user to docker group
usermod -aG docker ubuntu

# Run Jenkins container
docker run -d \
  -p 8080:8080 \
  --name jenkins \
  -v jenkins-data:/var/jenkins_home \
  jenkins/jenkins:lts

# Wait for Jenkins to start
while [ ! -f /var/jenkins_home/secrets/initialAdminPassword ]; do
  sleep 10
done

# Disable Jenkins Crumb
curl -X POST "http://admin:$(cat /var/jenkins_home/secrets/initialAdminPassword)@localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)"
