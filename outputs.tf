# output "node_details_group_eks" {
#   value = module.eks.eks_managed_node_groups
# }
output "eks_cluster_name" {
  value = module.eks.cluster_name
}
output "eks_cluster_arn" {
  value = module.eks.cluster_arn
}
output "eks_oidc" {
  value = module.eks.cluster_oidc_issuer_url
}
# output "eks_aws_config_map" {
#   value = module.eks.aws_auth_configmap_yaml
# }
output "eks_oidc_provider" {
  value = module.eks.oidc_provider
}
# output "vpc_subnets" {
#   value = module.vpc.private_subnets
# }
# output "vpc_subnets_cidr" {
#   value = module.vpc.private_subnets_cidr_blocks
# }
# output "vpc_azs" {
#   value = module.vpc.azs
# }
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
output "cluster-autosclaer-role-arn" {
  value = aws_iam_role.cluster-autoscaler-role.arn
}
output "cluster-version" {
  value = module.eks.cluster_version
}
