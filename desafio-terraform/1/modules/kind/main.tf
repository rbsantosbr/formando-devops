provider "kind" {}

resource "kind_cluster" "default" {
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