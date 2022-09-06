# Desafio Linux

As questões abaixo devem ser respondidas no arquivo [RESPOSTAS.md](RESPOSTAS.md) em um fork desse repositório.
O formato é livre. Quanto mais sucinto e direto, melhor. Envie o endereço do seu repositório para desafio@getupcloud.com.

# Preparação do ambiente

Sugerimos utilizar um sistema unix (linux, macos, \*bsd) ou [WSL](https://docs.microsoft.com/pt-br/windows/wsl/install).

Você precisa instalar o [VirtualBox](https://www.virtualbox.org) e opcionalmente (recomendado) o [Vagrant](https://www.vagrantup.com)

Baixe esse repositório e execute:

```
git clone https://github.com/getupcloud/formando-devops.git
cd desafio-linux
vagrant up
```

Para entrar na VM e iniciar as tarefas, execute:

```
vagrant ssh
```

O endereço IP público da VM pode ser obtido com o comando `ip addr show dev eth1`.

Você pode reiniciar a VM a qualquer momento utilizando a GUI do próprio VirtualBox.

## 1. Kernel e Boot loader - OK

O usuário `vagrant` está sem permissão para executar comandos root usando `sudo`.
Sua tarefa consiste em reativar a permissão no `sudo` para esse usuário.

Dica: lembre-se que você possui acesso "físico" ao host.

* Acessar o modo single user do SO pressionando "e" durante a inicialização:
* Editar a linha que inicia com linux, adicionando ao final o comando "rd.break"
* Remontar a partição /sysroot em modo de escrita, e acessar a partição
```bash
  mount -o remount,rx /sysroot
  
  chroot /sysroot
```
* Editar as permissões do usuário vagrant:
```bash
  usermod -aG wheel vagrant
  
  reboot -f
```

## 2. Usuários

### 2.1 Criação de usuários - OK

Crie um usuário com as seguintes características:

- username: `getup` (UID=1111)
- grupos: `getup` (principal, GID=2222) e `bin`
- permissão `sudo` para todos os comandos, sem solicitação de senha

No contexto do usuário root:
```bash
  group add -g 2222 getup
  useradd -g 2222 -G bin -u 1111 getup
  echo "getup ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/getup
```
## 3. SSH

### 3.1 Autenticação confiável - OK

O servidor SSH está configurado para aceitar autenticação por senha. No entanto esse método é desencorajado
pois apresenta alto nivel de fragilidade. Voce deve desativar autenticação por senhas e permitir apenas o uso
de par de chaves.

Editar o arquivo /etc/ssh/sshd_config e alterar as respectivas linhas com as opções:
```bash
  PermitRootLogin prohibit-password

  PasswordAuthentication no
```

### 3.2 Criação de chaves - OK

Crie uma chave SSH do tipo ECDSA (qualquer tamanho) para o usuário `vagrant`. Em seguida, use essa mesma chave
para acessar a VM.

No contexto do usuário vagrant:

```bash
   ssh-keygen -t ecdsa -b 256
   
   cd /home/vagrant/.ssh
   
   cat id_ecdsa.pub > authorized_keys

   ssh localhost
```

### 3.3 Análise de logs e configurações ssh

Utilizando a chave do arquivo [id_rsa-desafio-linux-devel.gz.b64](id_rsa-desafio-linzux-devel.gz.b64) deste repositório, acesse a VM com o usuário `devel`.

Dica: o arquivo pode ter sido criado em um SO que trata o fim de linha de forma diferente.

* No host local:

```bash
  sudo apt install -y dos2unix

  base64 -d id_rsa-desafio-linux-devel.gz.b64 | zcat | dos2unix > id_rsa

  ssh -i id_rsa devel@IP_DA_VM
```
* Na VM:

```bash
  dos2unix /home/devel/authorized_keys
```


## 4. Systemd - OK

Identifique e corrija os erros na inicialização do servico `nginx`.
Em seguida, execute o comando abaixo (exatamente como está) e apresente o resultado.
Note que o comando não deve falhar.

```
curl http://127.0.0.1
```

Dica: para iniciar o serviço utilize o comando `systemctl start nginx`.

* Editar o arquivo /etc/nginx/nginx.conf:

```bash
- Adicionar o ";" ao final da linha 8;

- Alterar as portas de listen para 80 (linhas 39 e 40)
```

* Editar o arquivo /lib/systemd/system/nginx.service:

```bash
- Remover o parâmetro -BROKEN do comando ExecStart=/usr/sbin/nginx (linha 13) 
```

* Atualizar o Daemon, iniciar o serviço e testar o acesso

```bash
  systemctl daemon-reload

  systemctl start nginx

  curl http://127.0.0.1
```

## 5. SSL

### 5.1 Criação de certificados

Utilizando o comando de sua preferencia (openssl, cfssl, etc...) crie uma autoridade certificadora (CA) para o hostname `desafio.local`.
Em seguida, utilizando esse CA para assinar, crie um certificado de web server para o hostname `www.desafio.local`.

### 5.2 Uso de certificados

Utilizando os certificados criados anteriormente, instale-os no serviço `nginx` de forma que este responda na porta `443` para o endereço
`www.desafio.local`. Certifique-se que o comando abaixo executa com sucesso e responde o mesmo que o desafio `4`. Voce pode inserir flags no comando
abaixo para utilizar seu CA.

```
curl https://www.desafio.local
```

## 6. Rede

### 6.1 Firewall

Faço o comando abaixo funcionar:

```
ping 8.8.8.8
```

### 6.2 HTTP

Apresente a resposta completa, com headers, da URL `https://httpbin.org/response-headers?hello=world`

```bash
  curl -i https://httpbin.org/response-headers?hello=world

  HTTP/2 200 
date: Tue, 06 Sep 2022 13:43:49 GMT
content-type: application/json
content-length: 89
server: gunicorn/19.9.0
hello: world
access-control-allow-origin: *
access-control-allow-credentials: true

{
  "Content-Length": "89", 
  "Content-Type": "application/json", 
  "hello": "world"
}

```

## Logs

Configure o `logrotate` para rotacionar arquivos do diretório `/var/log/nginx`

## 7. Filesystem

### 7.1 Expandir partição LVM

Aumente a partição LVM `sdb1` para `5Gi` e expanda o filesystem para o tamanho máximo.

```bash
  pvs ou pvdisplay

  umount /data

  lvchange -a n /dev/data_vg...

  cfdisk /dev/sdb1

  pvresize /dev/sdb1

  lvchange -a y /dev/data_vg...

 efsck -f  /dev/data_vg...

 resize2fs /dev/data_vg...

 mount /data

### 7.2 Criar partição LVM

Crie uma partição LVM `sdb2` com `5Gi` e formate com o filesystem `ext4`.

### 7.3 Criar partição XFS

Utilizando o disco `sdc` em sua todalidade (sem particionamento), formate com o filesystem `xfs`.
