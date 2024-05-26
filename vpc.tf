# VPC 모듈 호출
module "vpc" {
  source = "./modules/vpc"

  # VPC의 기본 CIDR 블록
  cidr_block = "10.0.0.0/16"
  # 퍼블릭 서브넷의 CIDR 블록
  public_subnet_cidr = "10.0.1.0/24"
  # 프라이빗 서브넷의 CIDR 블록
  private_subnet_cidr = "10.0.2.0/24"
  # 서브넷이 생성될 가용 영역
  availability_zone = "us-west-2a"
  # 리소스에 적용할 태그
  tags = { Environment = "prod" }
}