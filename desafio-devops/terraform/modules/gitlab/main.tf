resource "gitlab_project" "desafio-devops-projects" {
  count = length(var.project_name)
  name = var.project_name[count.index]
  description = "Repositorio para desafio final do programa Getup - Formando DevOps na Vida Real"
  visibility_level = "public"
  default_branch = "main"
}