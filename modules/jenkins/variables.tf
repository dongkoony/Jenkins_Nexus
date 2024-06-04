variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami" {
  description = "AMI ID for the Jenkins instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the Jenkins instance"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "security_group" {
  description = "Security group for the instance"
  type        = string
}

variable "user_data" {
  description = "User data script for the instance initialization"
  type        = string
}
