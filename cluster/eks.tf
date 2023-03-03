# data "aws_vpcs" "vpc_prebuilt" {
#   tags = {
#     Name = "poc-vpc"
#   }
# }

# data "aws_subnets" "private_subnets_default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpcs.vpc_prebuilt.ids[0]]
#   }
#   tags = {
#     Facing = "private"
#   }
# }
# data "aws_subnets" "public_subnets_default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpcs.vpc_prebuilt.ids[0]]
#   }
#   tags = {
#     Facing = "public"
#   }
# }

################################################################



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true
  enable_irsa                    = true
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  control_plane_subnet_ids       = concat(module.vpc.private_subnets, module.vpc.public_subnets)
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }


  # EKS Managed Node Group(s)

  eks_managed_node_groups = {
    blue = {
      min_size     = 1
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
    }
  }  


  # aws-auth configmap
    # manage_aws_auth_configmap = true

  #   aws_auth_roles = [
  #     {
  #       rolearn  = "arn:aws:iam::66666666666:role/role1"
  #       username = "role1"
  #       groups   = ["system:masters"]
  #     },
  #   ]

  #   aws_auth_users = [
  #     {
  #       userarn  = "arn:aws:iam::66666666666:user/user1"
  #       username = "user1"
  #       groups   = ["system:masters"]
  #     },
  #     {
  #       userarn  = "arn:aws:iam::66666666666:user/user2"
  #       username = "user2"
  #       groups   = ["system:masters"]
  #     },
  #   ]

  #   aws_auth_accounts = [
  #     "777777777777",
  #     "888888888888",
  #   ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region} --profile ${var.aws_profile}"
  }

  depends_on = [module.eks]
}