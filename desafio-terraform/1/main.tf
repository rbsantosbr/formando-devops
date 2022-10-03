resource "time_sleep" "wait_cluster" {
  create_duration = "10s"
  depends_on      = [kind_cluster.desafio-terraform]
}

data "local_file" "kube_config" {
  filename   = "infra-config"
  depends_on = [time_sleep.wait_cluster]
}

resource "kind_cluster" "desafio-terraform" {
  name = "infra"
  node_image = "kindest/node:v1.21.1"
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
    command = "kubectl taint node infra-control-plane dedicated=infra:NoSchedule"
  }
}

