variable "gitlab_token" {
  type = string
  description = "OAuth2 Token, Project, Group, Personal Access Token or CI Job Token"
}

variable "gitlab_root_group" {
  type = string
  description = "gitlab root group id"
}