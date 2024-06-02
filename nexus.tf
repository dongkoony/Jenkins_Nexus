module "nexus" {
  source = "./modules/ec2"

  name_prefix                 = "nexus"
  ami                         = "ami-01ed8ade75d4eee2f" # Ubuntu 22.04 LTS
  instance_type               = "t2.medium"
  subnet_id                   = module.vpc.public_subnet_id
  associate_public_ip_address = true
  vpc_id                      = module.vpc.vpc_id
  ingress_rules = [{
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }]
  key_name        = "Main"
  public_key_path = "C:/Users/djshin/.ssh/Main.pem"
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