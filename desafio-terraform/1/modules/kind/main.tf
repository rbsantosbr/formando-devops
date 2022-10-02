terraform {
  required_providers {
    kind = {
      source = "kyma-incubator/kind"
      version = "0.0.11"
    }
  }
}

resource "kind_cluster" "desafio-terraform" {
  name = var.cluster_name

  kind_config {
    kind = "Cluster"
    api_version = var.kubernetes_version
    node {
      role = "infra"
    }
    node {
      role = "app"
    }
  }
}

module "kind_cluster" {
  source  = "PePoDev/cluster/kind"
  version = "~> 0.1"

  cluster_name = "Cluster"
  enable_metrics_server = true
}