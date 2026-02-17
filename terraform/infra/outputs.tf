output "network" {
  description = "Networking services outputs"
  value = {
    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.public_subnet_ids
    igw_id     = module.vpc.igw_id
  }
}

output "eks" {
  description = "EKS outputs"
  value = {
    name     = module.eks.eks_cluster_name
    endpoint = module.eks.eks_cluster_endpoint
    version  = module.eks.eks_cluster_platform_version
    nodes = {
      group_name = module.eks.eks_node_group_name
    }
  }
}