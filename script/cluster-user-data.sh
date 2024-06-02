#!/bin/bash
# 업데이트 및 기본 패키지 설치
apt-get update -y
apt-get upgrade -y
apt-get install -y apache2

# Apache 웹 서버 시작 및 부팅 시 자동 시작 설정
systemctl start apache2
systemctl enable apache2

# 기본 웹 페이지 생성
echo "<html>
  <head>
    <title>Welcome to Your Cluster</title>
  </head>
  <body>
    <h1>Welcome to Your Cluster</h1>
    <p>This is the default web page for your cluster.</p>
  </body>
</html>" > /var/www/html/index.html

# 서버가 시작되었음을 확인하는 메시지
echo "Web server setup complete."
