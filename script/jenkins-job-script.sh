#!/bin/bash

# Jenkins 초기 비밀번호 가져오기
for i in {1..10}; do
  ssh -o StrictHostKeyChecking=no -i /home/ubuntu/Project/donghyeon.pem ubuntu@$1 'docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword' > initial_password.txt && break || sleep 30;
done

INITIAL_PASSWORD=$(cat initial_password.txt)

# Jenkins 서비스 대기 및 작업 생성
for i in {1..10}; do
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://admin:$INITIAL_PASSWORD@$1:8080")
  if [ "$HTTP_CODE" -eq 200 ]; then
    break
  fi
  sleep 30
done

# Get Crumb
CRUMB=$(curl -s "http://admin:$INITIAL_PASSWORD@$1:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

# Create Jenkins job
curl -X POST "http://admin:$INITIAL_PASSWORD@$1:8080/createItem?name=hello-world" --data-binary "$2" -H "Content-Type: application/xml" -H "$CRUMB"
