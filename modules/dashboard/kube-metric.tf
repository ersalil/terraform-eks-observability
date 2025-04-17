resource "grafana_dashboard" "kube-dash" {
    config_json = file("${path.module}/kube-metrics.json")
    folder = grafana_folder.kube-folder.uid
}