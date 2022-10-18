1. Execute o comando `hostname` em um container usando a imagem `alpine`. Certifique-se que o container será removido após a execução.
```bash
docker container run --name desafio-docker-1 --rm alpine hostname
```

2. Crie um container com a imagem `nginx` (versão 1.22), expondo a porta 80 do container para a porta 8080 do host.
```bash
docker container run --name desafio-docker-2 -d -p 8080:80 nginx:1.22
```

3. Faça o mesmo que a questão anterior (2), mas utilizando a porta 90 no container. O arquivo de configuração do nginx deve existir no host e ser read-only no container.
   
   Considerando que na imagem oficial do nginx as opções de servidor estão no arquivo default.conf, alterei este arquivo para receber o valor do listen através da **env** NGINX_PORT 

```bash
docker run --name desafio-docker-3 -e NGINX_PORT=90 -p 8080:90 -v $PWD/default.conf:/etc/nginx/conf.d/default.conf:ro -d nginx:1.22
```
4. Construa uma imagem para executar o programa abaixo:

```python
def main():
   print('Hello World in Python!')

if __name__ == '__main__':
  main()
``` 
```bash
docker run -it --rm --name desafio-docker-4 -v "$PWD":/usr/src/app -w /usr/src/app python:3 python hello-world.py
```

5. Execute um container da imagem `nginx` com limite de memória 128MB e 1/2 CPU.
```bash
docker container --name desafio-docker-5 run -d -m 128M --cpus 0.5 nginx
```

6. Qual o comando usado para limpar recursos como imagens, containers parados, cache de build e networks não utilizadas?
```bash
docker {container, network, image, ...} prune
```
7. Como você faria para extrair os comandos Dockerfile de uma imagem?
```bash
docker history <IMAGE:TAG>
```