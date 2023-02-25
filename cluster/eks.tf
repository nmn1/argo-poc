data "aws_vpcs" "vpc_prebuilt" {
  tags = {
    Name = "poc-vpc"
  }
}

data "aws_subnets" "private_subnets_default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.vpc_prebuilt.ids[0]]
  }
  tags = {
    Facing = "private"
  }
}
data "aws_subnets" "public_subnets_default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.vpc_prebuilt.ids[0]]
  }
  tags = {
    Facing = "public"
  }
}



module "eks" {
  source = "terraform-aws-modules/eks/aws"
  # version = "19.4.2"
  version = "18.30.3"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true
  enable_irsa                    = true
  vpc_id                         = data.aws_vpcs.vpc_prebuilt.ids[0]
  subnet_ids                     = data.aws_subnets.private_subnets_default.ids
  control_plane_subnet_ids       = concat(data.aws_subnets.private_subnets_default.ids, data.aws_subnets.public_subnets_default.ids)


  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      # most_recent = true
      addon_version = "v1.24.7-eksbuild.2"
      resolve_conflicts = "PRESERVE"
    }
    vpc-cni = {
      # most_recent = true
      addon_version = "v1.11.4-eksbuild.1"
      resolve_conflicts = "PRESERVE"
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }


  #   eks_managed_node_group_defaults = {
  #     instance_types = "t3.nano"
  #     disk_size = 50

  #   }

  eks_managed_node_groups = {
    first = {
      min_size     = 1
      max_size     = 2
      desired_size = 2

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
    }
  }
  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
  }
}


resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${module.eks.cluster_id} --region ${var.region} --profile nagarro_eks"
  }

  depends_on = [module.eks]
}