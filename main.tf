module "cluster" {
  source = "./modules/cluster"
  region = var.region
}

module "monitoring" {
  source = "./modules/monitoring"

  SOURCE_GMAIL_ID = var.SOURCE_GMAIL_ID
  SOURCE_AUTH_PASSWORD = var.SOURCE_AUTH_PASSWORD
  DESTINATION_GMAIL_ID = var.DESTINATION_GMAIL_ID

  providers = {
    helm = helm
    kubernetes = kubernetes
  }

  depends_on = [module.cluster]
}


module "dashboard" {
  source = "./modules/dashboard"
}


