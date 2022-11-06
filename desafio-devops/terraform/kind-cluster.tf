resource "kind_cluster" "desafio-devops" {
    name           = "k8s-cluster"
    wait_for_ready = true

  kind_config {
      kind        = "Cluster"
      api_version = "kind.x-k8s.io/v1alpha4"

      node {
          role = "control-plane"
      }

      node {
          role = "worker"

          kubeadm_config_patches = [
              "kind: JoinConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
          ]

          extra_port_mappings {
              container_port = 80
              host_port      = 80
          }
          extra_port_mappings {
              container_port = 443
              host_port      = 443
          }
      }

  }
  provisioner "local-exec" {
    command = "kubectl taint node k8s-cluster-control-plane dedicated=infra:NoSchedule"
  }
  provisioner "local-exec" {
    command = "kubectl create ns argocd"
  }
}