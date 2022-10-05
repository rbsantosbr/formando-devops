locals {
  today = timestamp()
  brasilia_tz = timeadd(local.today, "-3h")
  current_time = formatdate("DD-MMM-YYYY, ",local.brasilia_tz)

}

# data "template_file" "alo_mundo_tpl" {
#   template = file("./alo_mundo.txt.tpl")
#   vars = {
#     nome = var.nome
#     data = "${local.current_time}"
#     div  = var.div
#   }
# }

resource "local_file" "alo_mundo" {
  #content  = data.template_file.alo_mundo_tpl.rendered
  content = templatefile("./alo_mundo.txt.tpl", {nome = var.nome, data = "${local.current_time}", div = var.divisor})
  filename = "./alo_mundo.txt"
}