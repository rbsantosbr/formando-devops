module "my-cluster" {
    source = "./modules/kind"
    cluster_name = var.cluster_name
    kubernetes_version = var.kubernetes_version
}