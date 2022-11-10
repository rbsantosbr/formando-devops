variable "project_name" {
  description = "Nome do projeto. Usado para criação do repo."
  type        = list(string)
}

variable "gitlab_token" {
    description = "Token para autenticação no repo via API"
    type = string
}

variable "cluster_name" {
    description = "Nome do Cluster Kind"
    type = string
}
variable "kubernetes_version" {
    description = "Versão do Kubernetes"
    type = string
}