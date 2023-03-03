resource "kubernetes_service_account" "alb-controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.load_balancer_controller_irsa_role.iam_role_arn
    }
  }
  depends_on = [null_resource.update_kubeconfig]
}

resource "kubernetes_secret_v1" "alb_secret_token" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = "aws-load-balancer-controller"
    }
  }

  type       = "kubernetes.io/service-account-token"
  depends_on = [kubernetes_service_account.alb-controller]
}