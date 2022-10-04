output "api_endpoint" {
  description = "APIServer endpoint"
  value = kind_cluster.desafio-terraform.endpoint
}

output "kubeconfig" {
  description = "Kubeconfig for the cluster after it is created"
  value = kind_cluster.desafio-terraform.kubeconfig
}

output "client_certificate" {
  description = "Client certificate for authenticating to cluster"
  value = kind_cluster.desafio-terraform.client_certificate
}

output "client_key" {
  description = "Client certificate for authenticating to cluster"
  value = kind_cluster.desafio-terraform.client_key
}

output "cluster_ca_certificate" {
  description = "Output Name"
  value = kind_cluster.desafio-terraform.cluster_ca_certificate
}