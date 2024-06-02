# ./modules/ec2/outputs.tf

output "public_ip" {
  value = aws_instance.this.public_ip
}

output "instance" {
  description = "EC2 instance resource"
  value       = aws_instance.this
}