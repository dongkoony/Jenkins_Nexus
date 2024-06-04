#!/bin/bash

# 업데이트 및 기본 패키지 설치
apt-get update -y
apt-get upgrade -y

# Java 설치 (Jenkins 에이전트에 필요)
apt-get install -y openjdk-11-jdk

# Jenkins 에이전트 워크 디렉토리 생성
mkdir -p /home/ubuntu/agent
chown ubuntu:ubuntu /home/ubuntu/agent

# 에이전트 JAR 파일 다운로드
wget -O /home/ubuntu/agent/agent.jar http://<JENKINS_MASTER_IP>:8080/jnlpJars/agent.jar

# 에이전트 자동 시작을 위한 systemd 서비스 설정
echo "[Unit]
Description=Jenkins Agent
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/agent
ExecStart=/usr/bin/java -jar /home/ubuntu/agent/agent.jar -jnlpUrl http://<JENKINS_MASTER_IP>:8080/computer/<AGENT_NAME>/jenkins-agent.jnlp -secret <AGENT_SECRET>
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/jenkins-agent.service

# 서비스 시작 및 활성화
systemctl daemon-reload
systemctl start jenkins-agent
systemctl enable jenkins-agent
