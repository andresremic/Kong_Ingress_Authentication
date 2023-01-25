terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.48.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
  }
}

provider "kubernetes" {
  token                  = data.aws_eks_cluster_auth.testing_eks_cluster.token
  host                   = data.aws_eks_cluster.testing_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.testing_eks_cluster.certificate_authority[0].data)
}

data "aws_eks_cluster_auth" "testing_eks_cluster" {
  name = aws_eks_cluster.testing_eks_cluster.name
}

data "aws_eks_cluster" "testing_eks_cluster" {
  name = aws_eks_cluster.testing_eks_cluster.name
}
