Alo Mundo!

Meu nome é ${nome} e estou participando do Desafio Terraform da Getup/LinuxTips.

Hoje é dia ${data} e os números de 1 a 100 divisíveis por ${div} são:
${jsonencode({
  "result": toset([for numero in range(100) : numero%div == 0 ? "${numero}" : "null"]),  
})}