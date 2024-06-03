# ./jenkins.tf
module "jenkins" {
  source = "./modules/ec2"

  name_prefix                 = "jenkins"
  ami                         = "ami-01ed8ade75d4eee2f"
  instance_type               = "t2.small"
  subnet_id                   = module.vpc.public_subnet_id
  associate_public_ip_address = true
  vpc_id                      = module.vpc.vpc_id
  availability_zone           = "ap-northeast-2a"

  ingress_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  key_name        = "donghyeon"
  public_key_path = "/home/ubuntu/Project/donghyeon.pem"
  user_data       = file("script/jenkins-user-data.sh")
  tags            = { Environment = "prod" }
}

# output "jenkins_instance_public_ip" {
#   value = module.jenkins.public_ip
# }

# output "jenkins_instance_id" {
#   value = module.jenkins.instance_id
# }
