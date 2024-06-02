data "template_file" "job_xml" {
  template = file("${path.module}/job-github.xml")

  vars = {
    git_repo = "https://github.com/username/repo.git"
  }
}

resource "null_resource" "jenkins_jobs" {
  depends_on = [module.jenkins]

  # Jenkins 초기 비밀번호 가져오기
  provisioner "local-exec" {
    command = <<-EOF
      ssh -o StrictHostKeyChecking=no -i C:/Users/djshin/.ssh/Main.pem ubuntu@${module.jenkins.public_ip} 'docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword' > initial_password.txt
    EOF
  }

  # Jenkins 작업 생성
  provisioner "local-exec" {
    command = <<-EOF
      INITIAL_PASSWORD=$(cat initial_password.txt)
      curl -X POST http://admin:$INITIAL_PASSWORD@${module.jenkins.public_ip}:8080/createItem?name=hello-world --data-binary "${data.template_file.job_xml.rendered}" -H "Content-Type: application/xml"
    EOF
  }
}
