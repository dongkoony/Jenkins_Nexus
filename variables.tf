variable "repo_type" {
  description = "Repository type (github or nexus)"
  type        = string
  default     = "github"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for Nexus repository"
  type        = string
  default     = "my-nexus-bucket"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}