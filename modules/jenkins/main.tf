provider "aws" {
  region = var.region
}

resource "aws_instance" "jenkins" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  security_groups = [var.security_group]

  user_data = var.user_data

  tags = {
    Name = "Jenkins"
  }
}

output "public_ip" {
  value = aws_instance.jenkins.public_ip
}
