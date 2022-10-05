# Desafio Terraform

Em um fork desse repositório, responda as questões abaixo e envie o endereço para desafio@getupcloud.com.
O formato é livre. Quanto mais sucinto e direto, melhor.

Para cada questão prática 1, 2 e 3, crie os arquivos em um diretório com o número do desafio 1/, 2/ e 3/.

Utilize a versão que desejar do terraform.

## 1. Módulos


Para solução dessa questão, além do provider `kyma-incubator/kind`, eu utilizei também, como referência, o módulo [PePoDev/cluster](https://registry.terraform.io/modules/PePoDev/cluster/kind/latest), para entender como os recursos eram aplicados no cluster;

Não foi possível concluir a tarefa de renomear os nodes, pois não encontrei nenhuma referencia na documentação do kind, e no módulo `kyma-incubator/kind`, ele apenas considera se o nó será control-plane ou work;

Então considerei em aplicar o label `role=infra` e taint `dedicated=infra:NoSchedule`, no control-plane e o label `role=app` no worker;

Adicionei também, para fins de demonstração, o arquivo `terraform.tfvars` onde serão inseridas/modificadas as variáveis solicitadas no desafio.

## 2. Gerenciando recursos customizados

Utilizando o provider `scottwinkler/shell`, crie um módulo que gerencie a instalação de pacotes em um ambiente linux (local).
Você pode utilizar qualquer gerenciador de pacotes (rpm, deb, tgz, ...).

O módulo deve ser capaz de:

- Instalar e desinstalar um pacote no host;
- Atualizar um pacote já instalado com a nova versão especificada;
- Reinstalar um pacote que foi removido manualmente (fora do terraform).

O módulo deve permitir, no mínimo, as seguintes variáveis:

- install_pkgs: lista de pacotes a serem instalados, com versão;
- uninstall_pkgs: lista de pacotes a serem desinstalados.

## 3. Templates


Criação do arquivo `alo_mundo.txt.tpl` à partir do conteúdo do desafio;

Para criação do arquivo **txt**, utilizei a função `templatefile`;

Para mostrar o resultado dos números divisíveis, utilizei a função `jsonencode` no template do arquivo, pois a utilização do bloco `locals` estava retornando erro ao atribuir uma lista a uma variável (string).

## 4. Assumindo recursos

Descreva abaixo como você construiria um `resource` terraform a partir de um recurso já existente, como uma instância `ec2`.

Para construção do recurso, utilizamos o <em><strong>terraform import</strong></em>, seguindo os seguintes passos:

<ol>
  <li>Criação do bloco do recurso à ser criado, no root module;</li>
    <ol>
      <li><em>Ex.: resource "aws_instance" "teste"{};</em></li>
    </ol>
  <li>Indentificar o id do recurso que será importado;</li>
  <li>Executar o comando <em>terraform import aws_instance.teste</em> <strong>id_recurso;</strong></li>
  <li>Executar o comando <em>terraform state pull > arquivo.tfstate </em> e recuperar os argumentos que são requeridos pelo bloco do terraform recém criado;</li>
  <li>Executar o commando <em>terraform plan para validar o recurso recém criado.</em></li>
</ol> 
