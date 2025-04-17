terraform {
  required_providers {
    grafana = {
         source  = "grafana/grafana"
         version = ">= 2.9.0"
    }
  }
}

data "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "monitoring"
  }
}

resource "null_resource" "wait_for_grafana" {
  provisioner "local-exec" {
    command = <<EOT
      HOSTNAME="${data.kubernetes_service.grafana.status[0].load_balancer[0].ingress[0].hostname}"
      echo "Waiting for Grafana to be ready at $HOSTNAME..."
      for i in {1..40}; do
        if nslookup $HOSTNAME && curl -sSf http://$HOSTNAME/login > /dev/null; then
          echo "Grafana is up and reachable!"
          exit 0
        fi
        echo "Attempt $i: Grafana not ready, sleeping..."
        sleep 15
      done
      echo "Timeout: Grafana never became ready."
      exit 1
    EOT
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
  depends_on = [ null_resource.wait_for_grafana ]
}