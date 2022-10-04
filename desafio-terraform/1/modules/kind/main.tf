resource "time_sleep" "wait_cluster" {
  create_duration = "10s"
  depends_on      = [kind_cluster.desafio-terraform]
}

data "local_file" "kube_config" {
  filename   = "${var.cluster_name}-config"
  depends_on = [time_sleep.wait_cluster]
}

resource "kind_cluster" "desafio-terraform" {
  name = var.cluster_name
  node_image = "kindest/node:v${var.kubernetes_version}"
  wait_for_ready  = true
  
  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }
    node {
      role = "worker"
    }
  }
  provisioner "local-exec" {
    command = "kubectl taint node ${var.cluster_name}-control-plane dedicated=infra:NoSchedule"
  }
}

