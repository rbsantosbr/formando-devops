terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "3.18.0"
    }
    kind = {
      source = "kyma-incubator/kind"
      version = "0.0.11"
    }
  }
}