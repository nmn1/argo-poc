resource "helm_release" "ingress" {
  name       = "ingress"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.4.6"

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "region"
    value = var.region
  }
  set {
    name  = "vpcId"
    value = data.aws_vpcs.vpc_prebuilt.ids[0]
  }
  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}
