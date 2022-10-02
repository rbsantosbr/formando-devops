terraform {
  required_providers {
    kind = {
      source = "kyma-incubator/kind"
      version = "0.0.11"
    }
  }
}

module "my-cluster-kind"{
  source = "./modules/kind"
}