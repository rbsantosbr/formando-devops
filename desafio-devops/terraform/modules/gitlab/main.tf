resource "gitlab_project" "desafio-devops-projects" {
  count = length(var.project_name)
  name = var.project_name[count.index]
  description = "Repositorio para desafio final do programa Getup - Formando DevOps na Vida Real"
  visibility_level = "public"
  default_branch = "main"
}

resource "gitlab_repository_file" "readme" {
  project   = gitlab_project.desafio-devops-projects.id
  file_path = "README.md"
  branch    = "main"
  // content will be auto base64 encoded
  content        = "${var.project_name}"
  author_email   = "rbsantos85@gmail.com"
  author_name    = "Roberto Santos"
  commit_message = "feature: add readme file"
}