resource "helm_release" "aws_load_balancer_controller" {
  depends_on = [module.cluster]
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"

  set {
    name  = "clusterName"
    value = module.cluster.cluster_name
  }

  set {
    name  = "region"
    value = "us-east-2"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${module.cluster.alb_ingress_controller_role_name}"
  }
  
}
