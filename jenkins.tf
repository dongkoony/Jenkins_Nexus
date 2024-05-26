# Jenkins 서버 모듈 호출
module "jenkins" {
  source = "./modules/ec2"

  name_prefix                 = "jenkins" # 리소스 이름 접두사
  ami                         = "ami-0cff7528ff583bf9a" # Amazon Linux 2 AMI
  instance_type               = "t2.small" # 인스턴스 유형
  subnet_id                   = module.vpc.public_subnet_id # 퍼블릭 서브넷에 인스턴스 생성
  associate_public_ip_address = true # 퍼블릭 IP 주소 할당
  vpc_id                      = module.vpc.vpc_id # VPC ID

  # 보안 그룹의 인바운드 규칙 (포트 8080 열기)
  ingress_rules = [{
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 모든 IP 주소에서 접근 허용
  }]

  key_name        = "my-key-pair" # 키페어 이름
  public_key_path = "~/.ssh/id_rsa.pub" # 퍼블릭 키 파일 경로
  user_data       = file("jenkins-user-data.sh") # 사용자 데이터 스크립트
  tags            = { Environment = "prod" } # 태그
}