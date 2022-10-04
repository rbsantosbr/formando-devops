data "template_file" "alo_mundo_tpl" {
  template = "${file("./alo_mundo.txt.tpl")}"
  vars = {
    nome = var.nome
    data = "${local.current_time}"
  }
}

resource "local_file" "alo_mundo" {
  content = data.template_file.alo_mundo_tpl.rendered
  filename = "./alo_mundo.txt"
}