data "template_file" "job_xml" {
  template = file("${path.module}/job-github.xml")

  vars = {
    git_repo = "https://github.com/orgs/InsightEcom/repositories"
  }
}

# resource "null_resource" "wait_for_instance" {
#   provisioner "local-exec" {
#     command = <<EOT
# for i in {1..10}; do
#   ssh -o StrictHostKeyChecking=no -i /home/ubuntu/Project/donghyeon.pem ubuntu@${module.jenkins_master.public_ip} 'echo Instance is ready' && break || sleep 30;
# done
# EOT
#   }
# }

resource "null_resource" "jenkins_jobs" {
  depends_on = [module.jenkins_master, module.jenkins_worker]

  provisioner "local-exec" {
    command = <<EOT
chmod +x ./script/jenkins-job-script.sh
./script/jenkins-job-script.sh ${module.jenkins_master.public_ip} "${data.template_file.job_xml.rendered}"
EOT
  }
}
