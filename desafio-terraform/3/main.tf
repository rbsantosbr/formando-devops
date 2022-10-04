locals {
  today = timestamp()
  brasilia_tz = timeadd(local.today, "-3h")
  current_time = formatdate("DD-MMM-YYYY, ",local.brasilia_tz)

}

# locals {
#   j = var.div
#   teste = {
#     for i in range(1,100,1) : condition => (i % j == 0 ? "ok" : "erro") 
#   }
# }

# locals {  
#     iterator = {          
#       for i in range(100) :              
#         condition (i%div == 0 ? div_list[div_index] = i &&
#         div_index = div_index + 1 : "erro")       
#       }
# }