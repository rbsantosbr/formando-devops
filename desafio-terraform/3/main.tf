locals {
  today = timestamp()
  brasilia_tz = timeadd(local.today, "-3h")
  current_time = formatdate("DD-MMM-YYYY, ",local.brasilia_tz)

}

# output "time" {
#   value = "${local.current_time}"
# }