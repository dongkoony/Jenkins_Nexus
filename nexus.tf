module "nexus" {
  source = "./modules/ec2"

  name_prefix                 = "nexus"
  ami                         = "ami-01ed8ade75d4eee2f" # Ubuntu 22.04 LTS
  instance_type               = "t2.medium"
  subnet_id                   = module.vpc.public_subnet_id
  associate_public_ip_address = true
  vpc_id                      = module.vpc.vpc_id
  availability_zone           = "ap-northeast-2a" # 사용 가능한 예약 지역

  ingress_rules = [{
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
    {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  key_name        = "donghyeon"
  public_key_path = "/home/ubuntu/Project/donghyeon.pem"
  user_data       = data.template_file.nexus_user_data.rendered
  tags            = { Environment = "prod" }
}

data "template_file" "nexus_user_data" {
  template = file("script/nexus-user-data.sh") 

  vars = {
    s3_bucket_name = var.s3_bucket_name
    aws_region     = var.aws_region
  }
}