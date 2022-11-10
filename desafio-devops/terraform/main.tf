module "gitlab_repo" {
  source   = "./modules/gitlab"
  project_name     = var.project_name
  gitlab_token = var.gitlab_token
}

module "my-cluster" {
    source = "./modules/kind"
    cluster_name = var.cluster_name
    kubernetes_version = var.kubernetes_version
}