variable "divisor" {
  type    = number
  default = 15

  validation {
    condition     = var.divisor != 0
    error_message = "Não existe divisão por 0"
  }
}

variable "nome" {
  type    = string
  default = "Roberto"
}