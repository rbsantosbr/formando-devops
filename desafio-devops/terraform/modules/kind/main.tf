resource "kind_cluster" "desafio-devops" {
  name = var.cluster_name
  node_image = "kindest/node:v${var.kubernetes_version}"
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
    command = <<EOT
      kubectl taint node ${var.cluster_name}-control-plane dedicated=infra:NoSchedule
      kubectl create ns argocd
      kubectl create ns monitoring
      kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.16/manifests/install.yaml
      kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
      helm install prometheus-stack prometheus-community/kube-prometheus-stack --version 41.7.4 --namespace monitoring
      sleep 60
      kubectl apply -f https://gitlab.com/rbsantosbr/gitops/-/raw/main/application.yaml
    EOT
  }
}

resource "time_sleep" "wait_cluster" {
  create_duration = "10s"
  depends_on      = [kind_cluster.desafio-devops]
}

data "local_file" "kube_config" {
  filename   = "${var.cluster_name}-config"
  depends_on = [time_sleep.wait_cluster]
}