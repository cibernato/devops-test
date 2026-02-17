locals {
  cluster_role = try(aws_iam_role.eks_role[0].arn, var.iam_role_arn)
  nodes_role   = try(aws_iam_role.node_role[0].arn, var.nodes_iam_role_arn)
}
