terraform {
  required_providers {
    kind = {
      source = "kyma-incubator/kind"
      version = "0.0.11"
    }
  }
}

provider "kind" {
  # Configuration options
}

resource "kind_cluster" "default" {
    name = "test-cluster"
}