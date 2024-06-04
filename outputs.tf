# ./outputs.tf

# EKS Outputs
# output "eks_cluster_id" {
#   value = module.eks.cluster_id
# }

# output "eks_cluster_endpoint" {
#   value = module.eks.cluster_endpoint
# }

# output "eks_cluster_security_group_id" {
#   value = module.eks.cluster_security_group_id
# }

# output "eks_node_group_arns" {
#   value = module.eks.node_group_arns
# }

# output "eks_node_group_security_group_ids" {
#   value = module.eks.node_group_security_group_ids
# }

# Jenkins Outputs
output "jenkins_master_public_ip" {
  value = module.jenkins_master.public_ip
}

output "jenkins_master_instance_id" {
  value = module.jenkins_master.instance_id
}

output "jenkins_worker_public_ips" {
  value = module.jenkins_worker.*.public_ip
}

output "jenkins_worker_instance_ids" {
  value = module.jenkins_worker.*.instance_id
}
