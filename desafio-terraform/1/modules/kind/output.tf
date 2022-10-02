output "api_endpoint" {
  value = kind_cluster.desafio-terraform.endpoint
}

output "kubeconfig" {
  value = kind_cluster.desafio-terraform.kubeconfig
}

output "client_certificate" {
  value = kind_cluster.desafio-terraform.client_certificate
}

output "client_key" {
  value = kind_cluster.desafio-terraform.client_key
}

output "cluster_ca_certificate" {
  value = kind_cluster.desafio-terraform.cluster_ca_certificate
}