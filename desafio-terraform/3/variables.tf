variable "div" {
  type = number
  default = 15

  validation {
    condition     = var.div != 0
    error_message = "Não existe divisão por 0"
  }
}

variable "nome" {
  type = string
  default = "Roberto"
}

# variable "resultado" {
#   type = list(number)
#   default = "${local.dividendo}"
# }
