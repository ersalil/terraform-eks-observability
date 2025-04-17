data "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "monitoring"
  }
}

provider "grafana" {
  url  = "http://${data.kubernetes_service.grafana.status[0].load_balancer[0].ingress[0].hostname}"
  auth = "admin:admin"
}

#creating folder for dashboards related to kubernetes
resource "grafana_folder" "kube-folder" {
  title = "Kubernetes"
  uid   = null
}