output "grafana_lb_url" {
  value = data.kubernetes_service.grafana.status[0].load_balancer[0].ingress[0].hostname
  description = "The URL of the Grafana Load Balancer"
}