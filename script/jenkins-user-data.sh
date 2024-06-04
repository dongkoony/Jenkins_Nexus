#!/bin/bash

# Docker 설치
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 현재 사용자를 docker 그룹에 추가
usermod -aG docker ubuntu
newgrp docker

# Jenkins 컨테이너 실행
docker run -d \
  -p 8080:8080 \
  --name jenkins \
  -v jenkins-data:/var/jenkins_home \
  jenkins/jenkins:lts

# Jenkins가 시작될 때까지 대기
while [ ! -f /var/jenkins_home/secrets/initialAdminPassword ]; do
  sleep 10
done

# Jenkins Crumb을 가져오기 위한 요청
crumb=$(curl -u "admin:$(cat /var/jenkins_home/secrets/initialAdminPassword)" -s 'http://localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')

# 예시: Jenkins에 Job을 생성하기 위한 요청 (CSRF 보호 해결)
curl -u "admin:$(cat /var/jenkins_home/secrets/initialAdminPassword)" -H "$crumb" -X POST 'http://localhost:8080/createItem?name=my-job' --data-binary @job-config.xml -H "Content-Type: text/xml"
