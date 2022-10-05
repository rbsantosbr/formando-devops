locals {
  today = timestamp()
  brasilia_tz = timeadd(local.today, "-3h")
  current_time = formatdate("DD-MMM-YYYY, ",local.brasilia_tz)

}

locals {
  result = toset([
    for i in range(0,100,1) : i%var.div == 0 ? i : " "
  ])

}

output "result" {
  value = local.result
}