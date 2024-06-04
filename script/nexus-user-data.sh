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

# Run Nexus container
docker run -d \
  -p 8081:8081 \
  --name nexus \
  -e NEXUS_SECURITY_RESOURCE="nexus-resource.xml" \
  -v nexus-data:/nexus-data \
  --mount type=bind,source=/opt/nexus/resources,target=/nexus-resources \
  sonatype/nexus3:latest

# Configure Nexus to use S3 for blob store
cat << EOF > /opt/nexus/resources/nexus-resource.xml
<?xml version="1.0" encoding="UTF-8"?>
<resource-configs>
  <blobstores>
    <blobstore name="s3" type="S3">
      <bucket-name>${s3_bucket_name}</bucket-name>
      <region>${aws_region}</region>
    </blobstore>
  </blobstores>
</resource-configs>
EOF