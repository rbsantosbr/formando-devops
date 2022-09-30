terraform {
  required_providers {
    kind = {
      source = "kyma-incubator/kind"
      version = "0.0.11"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "default" {
  name = "infra"

  kind_config {
    kind = "Infra"
    api_version = "kind.x-k8s.io/v1alpha4"
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

  cluster_name = "Infra"
  enable_metrics_server = true
}