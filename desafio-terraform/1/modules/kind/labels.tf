resource "kubernetes_labels" "app" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "infra-worker"
  }
  labels = {
    "role" = "app"
  }
}

resource "kubernetes_labels" "infra" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "infra-control-plane"
  }
  labels = {
    "role" = "infra"
  }
}