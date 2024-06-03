module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = "10.0.0.0/16"
  private_subnet_cidr = "10.0.1.0/24"
  public_subnet_cidr  = "10.0.2.0/24"
  availability_zone   = "ap-northeast-2a"
  vpc_name            = "my-vpc"
}

resource "aws_internet_gateway" "this" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "${module.vpc.vpc_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${module.vpc.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = module.vpc.public_subnet_id
  route_table_id = aws_route_table.public.id
}
