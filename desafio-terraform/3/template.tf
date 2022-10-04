data "template_file" "alo_mundo_tpl" {
  template = "${file("./alo_mundo.txt.tpl")}"
  vars = {
    nome = var.nome
    data = "${local.current_time}"
    div = var.div
  }
}

resource "local_file" "alo_mundo" {
  content = data.template_file.alo_mundo_tpl.rendered
  filename = "./alo_mundo.txt"
}

# resource "null_resource" "teste" {
#    resultado = "${local.dividendo}"
# }

# output "teste_id" {
#   value = ["${null_resource.teste.*.id}"]
# }

# output "teste_length" {
#   value = length(null_resource.teste)
# }