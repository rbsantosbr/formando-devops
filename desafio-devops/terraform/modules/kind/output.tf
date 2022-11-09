output "api_endpoint" {
  description = "APIServer endpoint"
  value = kind_cluster.desafio-devops.endpoint
}

output "kubeconfig" {
  description = "Kubeconfig for the cluster after it is created"
  value = kind_cluster.desafio-devops.kubeconfig
}

output "client_certificate" {
  description = "Client certificate for authenticating to cluster"
  value = kind_cluster.desafio-devops.client_certificate
}

output "client_key" {
  description = "Client certificate for authenticating to cluster"
  value = kind_cluster.desafio-devops.client_key
}

output "cluster_ca_certificate" {
  description = "Output Name"
  value = kind_cluster.desafio-devops.cluster_ca_certificate
}