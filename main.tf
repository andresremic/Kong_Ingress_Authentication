locals {
  tags = {
    Terraform    = true
    ManagedBy    = "andres.remic@dlabs.si"
    CreationDate = "04-01-2023"
    LastUpdate   = formatdate("DD-MM-YYYY", timestamp())
  }
}

resource "aws_eks_cluster" "testing_eks_cluster" {
  name     = "testing_eks_cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }

  depends_on = [
    aws_iam_role.eks_role,
    aws_iam_role_policy_attachment.eks_cluster_role_policy_attachment
  ]

  tags = local.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


resource "aws_eks_node_group" "eks_cluster_node_group" {
  cluster_name    = aws_eks_cluster.testing_eks_cluster.name
  node_group_name = "testing_eks_cluster_node_group"
  node_role_arn   = aws_iam_role.eks_cluster_node_group.arn
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_CNI_policy_attachment,
    aws_iam_role_policy_attachment.eks_cluster_node_group_ECR_RO_policy_attachment,
    aws_iam_role_policy_attachment.eks_worker_node_policy_attachment
  ]

  tags = local.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
