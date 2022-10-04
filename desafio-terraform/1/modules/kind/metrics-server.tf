data "kubectl_file_documents" "metrics_server" {
  content = file("./modules/kind/metrics-server.yaml")
}

resource "kubectl_manifest" "test" {
    count     = length(data.kubectl_file_documents.metrics_server.documents)
    yaml_body = element(data.kubectl_file_documents.metrics_server.documents, count.index)
    depends_on = [
      kind_cluster.desafio-terraform
    ]
}