terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    }
    kubectl = {
      source  = "bnu0/kubectl"
      version = "0.27.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.9.0"
    }
  }

  # backend "s3" {
  #   bucket = "salil-terraform"
  #   key    = "eks_prom_stack.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.region
}


data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_name
}

data "aws_caller_identity" "current" {}


provider "helm" {
  kubernetes {
    host                   = module.cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.cluster.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  host                   = module.cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.cluster.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

