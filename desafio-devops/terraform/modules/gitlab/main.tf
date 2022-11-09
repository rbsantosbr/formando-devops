resource "gitlab_project" "desafio-devops-projects" {
  name = var.project_name
  description = "Repositorio para desafio final do programa Getup - Formando DevOps na Vida Real"
  visibility_level = "public"
}

# resource "gitlab_repository_file" "readme" {
#   project = gitlab_project.desafio-devops-podinfo.id
#   file_path = "README.md"
#   branch = "main"
#   content = base64encode ("# Desafio DevOps")
#   author_email = "rbsantos85@gmail.com"
#   author_name = "Roberto Santos"
#   commit_message = "Cria arquivo README.md"
# }

# resource "gitlab_group" "formandoDevOps" {
#   name = "desafio-devops"
#   path = "desafio-devops"
#   description = "Repositórios do desafio-devops"
#   parent_id = var.gitlab_root_group
#   visibility_level = "public"
# }

# data "gitlab_group" "data-desafio-devops" {
#  full_path = "formandodevops/desafio-devops"
#  depends_on = [
#    gitlab_group.formandoDevOps
#  ]
# }