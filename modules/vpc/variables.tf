variable "cidr_block" {
  description = "VPC의 기본 CIDR 블록"
  type        = string
}

variable "public_subnet_cidr" {
  description = "퍼블릭 서브넷의 CIDR 블록"
  type        = string
}

variable "private_subnet_cidr" {
  description = "프라이빗 서브넷의 CIDR 블록"
  type        = string
}

variable "availability_zone" {
  description = "서브넷이 생성될 가용 영역"
  type        = string
}

variable "tags" {
  description = "리소스에 적용할 태그"
  type        = map(string)
  default     = {}
}