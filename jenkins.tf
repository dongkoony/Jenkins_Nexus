# ./jenkins.tf

# 젠킨스 마스터 인스턴스
module "jenkins_master" {
  source = "./modules/ec2"
  name_prefix = "jenkins"
  ami         = "ami-01ed8ade75d4eee2f" # ubuntu 22.04 LTS
  instance_type = "t2.small"
  subnet_id   = module.vpc.public_subnet_id
  associate_public_ip_address = true
  vpc_id      = module.vpc.vpc_id
  availability_zone = "ap-northeast-2a"

  ingress_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # 모든 IP에서 접근 허용
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # 모든 IP에서 접근 허용
    }
  ]

  key_name        = "donghyeon"
  public_key_path = "/home/ubuntu/Project/donghyeon.pem"
  user_data       = file("script/jenkins-user-data.sh")
  tags = {
    Name = "Jenkins-Master"
  }
}

# 젠킨스 워커 노드 인스턴스
module "jenkins_worker" {
  source = "./modules/ec2"
  count  = 2
  name_prefix = "jenkins-worker-${count.index + 1}"
  ami         = "ami-01ed8ade75d4eee2f"
  instance_type = "t3.medium"
  subnet_id   = module.vpc.private_subnet_id
  associate_public_ip_address = true
  vpc_id      = module.vpc.vpc_id
  availability_zone = element(["ap-northeast-2b", "ap-northeast-2c"], count.index)

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # 모든 IP에서 접근 허용
    }
  ]

  key_name        = "donghyeon"
  public_key_path = "/home/ubuntu/Project/donghyeon.pem"
  user_data       = file("script/cluster-user-data.sh")
    tags = {
    Name = "JenkinsAgent-${count.index + 1}"
  }
}
