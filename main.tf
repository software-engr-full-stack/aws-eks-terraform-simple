provider "aws" {
  region = local.region
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.4"

  cluster_name                   = local.name
  cluster_endpoint_public_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "BOTTLEROCKET_x86_64"

    # t2.micro is too small. kubectl run test-pod --image=nginx won't run.
    instance_types = ["t2.small"]

    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    test_eks_cluster = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      # t2.micro is too small. kubectl run test-pod --image=nginx won't run.
      instance_types = ["t2.small"]

      capacity_type  = "SPOT"

      tags = {
        Name = local.name
      }
    }
  }

  tags = local.tags
}

# See # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1801#issuecomment-1028736746
# All three EKS add-on modules can be put inside the EKS module but
# race conditions will occur when creating a cluster from scratch.
resource "aws_eks_addon" "coredns" {
  cluster_name = module.eks.cluster_name
  addon_name   = "coredns"

  resolve_conflicts = "OVERWRITE"

  depends_on = [module.eks.eks_managed_node_groups]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = module.eks.cluster_name
  addon_name   = "kube-proxy"

  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = module.eks.cluster_name
  addon_name   = "vpc-cni"

  resolve_conflicts = "OVERWRITE"

  depends_on = [module.eks.eks_managed_node_groups]
}
