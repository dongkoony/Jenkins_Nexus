# 클러스터 인스턴스 모듈 호출 (3개)
module "cluster" {
  source = "./modules/ec2"
  count  = 3 # 3개의 인스턴스 생성

  # count.index를 이용하여 각 인스턴스의 이름을 다르게 지정
  name_prefix                 = "cluster-${count.index + 1}"
  ami                         = "ami-0cff7528ff583bf9a" # Amazon Linux 2 AMI
  instance_type               = "t3.medium"             # 인스턴스 유형
  subnet_id                   = module.vpc.private_subnet_id # 프라이빗 서브넷에 인스턴스 생성
  associate_public_ip_address = false                   # 퍼블릭 IP 주소 미할당
  vpc_id                      = module.vpc.vpc_id        # VPC ID

  # 보안 그룹의 인바운드 규칙 (포트 80 열기)
  ingress_rules = [{
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block] # VPC CIDR 블록에서 접근 허용
  }]

  key_name        = "my-key-pair" # 키페어 이름
  public_key_path = "~/.ssh/id_rsa.pub" # 퍼블릭 키 파일 경로
  user_data       = file("cluster-user-data.sh") # 사용자 데이터 스크립트
  tags            = { Environment = "prod" } # 태그
}