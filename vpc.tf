module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "testing-eks-vpc"

  cidr = "15.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["15.0.1.0/24", "15.0.2.0/24", "15.0.3.0/24"]
  public_subnets  = ["15.0.4.0/24", "15.0.5.0/24", "15.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = merge({
    "kubernetes.io/cluster/testing_eks_cluster" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }, local.tags)

  private_subnet_tags = merge({
    "kubernetes.io/cluster/testing_eks_cluster" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }, local.tags)
}

data "aws_availability_zones" "available" {}
