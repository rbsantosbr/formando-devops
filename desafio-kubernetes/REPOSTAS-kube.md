# Desafio Kubernetes

As questões abaixo devem ser respondidas no arquivo [RESPOSTAS-kube.md](RESPOSTAS-kube.md) em um fork desse repositório. Por ordem e numeradamente. O formato é livre, mas recomenda-se as linhas de comando utilizadas para criar ou alterar resources de cada questão na maioria dos casos. Quanto mais sucinto e direto, melhor. Envie o endereço do seu repositório para desafio@getupcloud.com.

Ex. de respostas:

### 1 - linha de comando para criar um resource x

```bash
    kubectl cria um resource x
```

ou

### 2 - crie um resource y

```yaml
    apiVersion: xyz/v1
    Kind: XYZ
    metadata:
      name: y
      namespace: x
    spec:
    ....
```

---
---

## Caso precise de um kubernetes, segue uma dica rápida para a criação de um cluster kubernetes kind, no seu linux ou mac, ja com docker instalado.

1 - tenha certeza que ja tenha docker instalado na sua maquina

2 - baixe e instale o kind 

```bash
# Linux
sudo curl -Lo /usr/local/bin/kind https://github.com/kubernetes-sigs/kind/releases/download/v0.16.0/kind-linux-amd64
sudo chmod +x /usr/local/bin/kind
# MacOS
sudo curl -Lo /usr/local/bin/kind  https://github.com/kubernetes-sigs/kind/releases/download/v0.16.0/kind-darwin-arm64
sudo chmod +x /usr/local/bin/kind
```

3 - salve e use esse arquivo abaixo para subir seu cluster, ele é um exemplo de como o kind é poderoso e pode te ajudar a subir um kubernetes rapido e facil

```bash
cat << EOF | kind create cluster --name meuk8s --config -
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
```

---
---

## Bora começar !!!

1 - com uma unica linha de comando capture somente linhas que contenham "erro" do log do pod `serverweb` no namespace `meusite` que tenha a label `app: ovo`.

2 - crie o manifesto de um recurso que seja executado em todos os nós do cluster com a imagem `nginx:latest` com nome `meu-spread`, nao sobreponha ou remova qualquer taint de qualquer um dos nós.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: meuspread
  name: meuspread
spec:
  replicas: 3
  selector:
    matchLabels:
      app: meuspread
  template:
    metadata:
      labels:
        app: meuspread
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        ports:
        - containerPort: 80
        resources: {}
      tolerations:
      - key: "node-role.kubernetes.io/control-plane"
        operator: "Exists"
        effect: NoSchedule
status: {}
```

Poderíamos também utilizar o recurso Daemonset para recursos de monitoramento ou logs em cada nó:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: meu-spread
spec:
  selector:
    matchLabels:
      app: meu-spread
  template:
    metadata:
      labels:
        app: meu-spread
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        resources: {}
      tolerations:
      - key: "node-role.kubernetes.io/control-plane"
        operator: "Exists"
        effect: NoSchedule
```

3 - crie um deploy `meu-webserver` com a imagem `nginx:latest` e um initContainer com a imagem `alpine`. O initContainer deve criar um arquivo /app/index.html, tenha o conteudo "HelloGetup" e compartilhe com o container de nginx que só poderá ser inicializado se o arquivo foi criado.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: meu-webserver
  name: meu-webserver
spec:
  replicas: 1
  selector:
    matchLabels:
      app: meu-webserver
  template:
    metadata:
      labels:
        app: meu-webserver
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: nginx-vol 
        resources: {}
      initContainers:
      - image: alpine
        name: alpine
        command: ["sh","-c","echo HelloGetup >> /app/index.html"]
        volumeMounts:
        - mountPath: /app
          name: nginx-vol
      volumes:
      - name: nginx-vol
        emptyDir: {}
status: {}
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: meuweb
  name: meuweb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: meuweb
  strategy: {}
  template:
    metadata:
      labels:
        app: meuweb
    spec:
      containers:
      - image: nginx:1.16
        name: nginx
        ports:
        - containerPort: 80
        resources: {}
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: "node-role.kubernetes.io/control-plane"
                operator: "Exists"
                effect: NoSchedule
      tolerations:
      - key: "node-role.kubernetes.io/control-plane"
        operator: "Exists"
        effect: NoSchedule
status: {}
```
4 - crie um deploy chamado `meuweb` com a imagem `nginx:1.16` que seja executado exclusivamente no node master.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: meuweb
  name: meuweb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: meuweb
  strategy: {}
  template:
    metadata:
      labels:
        app: meuweb
    spec:
      containers:
      - image: nginx:1.16
        name: nginx
        ports:
        - containerPort: 80
        resources: {}
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: "node-role.kubernetes.io/control-plane"
                operator: "Exists"
                effect: NoSchedule
      tolerations:
      - key: "node-role.kubernetes.io/control-plane"
        operator: "Exists"
        effect: NoSchedule
status: {}
```

Outra opção é utilizar o **nodeSelector**

5 - com uma unica linha de comando altere a imagem desse pod `meuweb` para `nginx:1.19` e salve o comando aqui no repositorio.
```bash
k set image deploy meuweb nginx=nginx1.19
```
6 - quais linhas de comando para instalar o ingress-nginx controller usando helm, com os seguintes parametros;

    helm repository : https://kubernetes.github.io/ingress-nginx

    values do ingress-nginx : 
    controller:
      hostPort:
        enabled: true
      service:
        type: NodePort
      updateStrategy:
        type: Recreate

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm install my-ingress-nginx ingress-nginx/ingress-nginx --version 4.3.0 --set \ controller.hostPort.enabled=true,controller.service.type=NodePort,controller.updateStrategy.type=Recreate
```

7 - quais as linhas de comando para: 

    criar um deploy chamado `pombo` com a imagem de `nginx:1.11.9-alpine` com 4 réplicas;
    alterar a imagem para `nginx:1.16` e registre na annotation automaticamente;
    alterar a imagem para 1.19 e registre novamente; 
    imprimir a historia de alterações desse deploy;
    voltar para versão 1.11.9-alpine baseado no historico que voce registrou.
    criar um ingress chamado `web` para esse deploy

```bash
k create deploy pombo --image nginx:1.11.9-alpine --replicas 4 --port 80

k set image deploy pombo nginx=nginx:1.16 --record

k set image deploy pombo nginx=nginx:1.19 --record

k rollout history deploy pombo

k rollout undo deploy pombo --to-revision=1

k expose deployment pombo --port=80 --target-port=80 && k create ingress web --rule="desafio-devops.local/*=pombo:80"

```

8 - linhas de comando para; 

    criar um deploy chamado `guardaroupa` com a imagem `redis`;
    criar um serviço do tipo ClusterIP desse redis com as devidas portas.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: guardaroupa
  name: guardaroupa
spec:
  replicas: 1
  selector:
    matchLabels:
      app: guardaroupa
  strategy: {}
  template:
    metadata:
      labels:
        app: guardaroupa
    spec:
      containers:
      - image: redis
        name: redis
        ports:
        - containerPort: 6379
        resources: {}
status: {}

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: guardaroupa
  name: guardaroupa
spec:
  ports:
  - name: 6379-6379
    port: 6379
    protocol: TCP
    targetPort: 6379
  selector:
    app: guardaroupa
  type: ClusterIP
status:
  loadBalancer: {}
```
9 - crie um recurso para aplicação stateful com os seguintes parametros:

    - nome : meusiteset
    - imagem nginx 
    - no namespace backend
    - com 3 réplicas
    - disco de 1Gi
    - montado em /data
    - sufixo dos pvc: data

```yaml
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: backend
spec: {}
status: {}

---

apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: meusiteset
  name: meusiteset
  namespace: backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: meusiteset
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: meusiteset
    spec:
      containers:
      - image: nginx
        name: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /data
          name: vol-data
        resources: {}
      volumes:
      - name: vol-data
        persistentVolumeClaim:
          claimName: pvc-data        
status: {}

---

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: portworx-io-priority-high
  namespace: backend
provisioner: kubernetes.io/portworx-volume
parameters:
  repl: "1"
  snap_interval:   "70"
  priority_io:  "high"

# apiVersion: storage.k8s.io/v1
# kind: StorageClass
# metadata:
#   name: local-storage
# provisioner: kubernetes.io/no-provisioner
# volumeBindingMode: WaitForFirstConsumer

---

apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-data
spec:
  accessModes:
  - ReadWriteMany
  capacity:
    storage: 1Gi
  hostPath:
    path: /data
  storageClassName: portworx-io-priority-high

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-data
  namespace: backend
spec:
  accessModes:
  - ReadWriteMany
  storageClassName: portworx-io-priority-high
  resources:
    requests:
      storage: 1Gi
```

10 - crie um recurso com 2 replicas, chamado `balaclava` com a imagem `redis`, usando as labels nos pods, replicaset e deployment, `backend=balaclava` e `minhachave=semvalor` no namespace `backend`.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: backend
spec: {}
status: {}

---

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    backend: balaclava
    minhachave: semvalor
  name: balaclava
  namespace: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      backend: balaclava
      minhachave: semvalor
  strategy: {}
  template:
    metadata:
      labels:
        backend: balaclava
        minhachave: semvalor
    spec:
      containers:
      - image: redis
        name: redis
        ports:
        - containerPort: 6379
        resources: {}
status: {}
```

11 - linha de comando para listar todos os serviços do cluster do tipo `LoadBalancer` mostrando tambem `selectors`.
```bash
k get svc -o json | jq -r '.items[] | select(.spec.type == "LoadBalancer") | .metadata.name,.spec.selector'
```

12 - com uma linha de comando, crie uma secret chamada `meusegredo` no namespace `segredosdesucesso` com os dados, `segredo=azul` e com o conteudo do texto abaixo.

```bash
   # cat chave-secreta
     aW5ncmVzcy1uZ2lueCAgIGluZ3Jlc3MtbmdpbngtY29udHJvbGxlciAgICAgICAgICAgICAgICAg
     ICAgICAgICAgICAgTG9hZEJhbGFuY2VyICAgMTAuMjMzLjE3Ljg0ICAgIDE5Mi4xNjguMS4zNSAg
     IDgwOjMxOTE2L1RDUCw0NDM6MzE3OTQvVENQICAgICAyM2ggICBhcHAua3ViZXJuZXRlcy5pby9j
     b21wb25lbnQ9Y29udHJvbGxlcixhcHAua3ViZXJuZXRlcy5pby9pbnN0YW5jZT1pbmdyZXNzLW5n
     aW54LGFwcC5rdWJlcm5ldGVzLmlvL25hbWU9aW5ncmVzcy1uZ
```
```bash
k create secret generic meusegredo -n segredosdesucesso --from-literal=segredo=azul --from-file=chave-secreta
```

13 - qual a linha de comando para criar um configmap chamado `configsite` no namespace `site`. Deve conter uma entrada `index.html` que contenha seu nome.

```bash
k create ns site && k create configmap configsite -n site --from-literal=index.html=Roberto
```

14 - crie um recurso chamado `meudeploy`, com a imagem `nginx:latest`, que utilize a secret criada no exercicio 11 como arquivos no diretorio `/app`.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: meudeploy
  name: meudeploy
  namespace: segredosdesucesso
spec:
  replicas: 1
  selector:
    matchLabels:
      app: meudeploy
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: meudeploy
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /app
          name: app-secret-vol
        resources: {}
      volumes:
      - name: app-secret-vol
        secret:
          secretName: meusegredo
status: {}
```

15 - crie um recurso chamado `depconfigs`, com a imagem `nginx:latest`, que utilize o configMap criado no exercicio 12 e use seu index.html como pagina principal desse recurso.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: depconfigs
  name: depconfigs
  namespace: site
spec:
  replicas: 1
  selector:
    matchLabels:
      app: depsconfigs
  template:
    metadata:
      labels:
        app: depsconfigs
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: configmap-vol 
        resources: {}
      volumes:
      - name: configmap-vol
        configMap:
          name: configsite
status: {}
```

16 - crie um novo recurso chamado `meudeploy-2` com a imagem `nginx:1.16` , com a label `chaves=secretas` e que use todo conteudo da secret como variavel de ambiente criada no exercicio 11.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    chaves: secretas
  name: meudeploy-2
  namespace: segredosdesucesso
spec:
  replicas: 1
  selector:
    matchLabels:
      chaves: secretas
  strategy: {}
  template:
    metadata:
      labels:
        chaves: secretas
    spec:
      containers:
      - image: nginx:1.16
        name: nginx
        ports:
        - containerPort: 80
        envFrom:
        - secretRef:
            name: meusegredo
        resources: {}
status: {}
```

17 - linhas de comando que;

    crie um namespace `cabeludo`;
    um deploy chamado `cabelo` usando a imagem `nginx:latest`; 
    uma secret chamada `acesso` com as entradas `username: pavao` e `password: asabranca`;
    exponha variaveis de ambiente chamados USUARIO para username e SENHA para a password.

```bash
k create ns cabeludo

k create deploy cabelo --image nginx:latest

k create secret generic acesso --from-literal=username=pavao --from-literal=password=asabranca

export USUARIO=$(k get secret acesso -o jsonpath="{.data.username}" | base64 --decode; echo)

export SENHA=$(k get secret acesso -o jsonpath="{.data.password}" | base64 --decode; echo)
```

18 - crie um deploy `redis` usando a imagem com o mesmo nome, no namespace `cachehits` e que tenha o ponto de montagem `/data/redis` de um volume chamado `app-cache` que NÂO deverá ser persistente.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: cachehits
spec: {}
status: {}

---

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: redis
  name: redis
  namespace: cachehits
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  strategy: {}
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - image: redis
        name: redis
        ports:
        - containerPort: 6379
        volumeMounts:
        - mountPath: /data/redis
          name: app-cache
        resources: {}
      volumes:
      - name: app-cache
        emptyDir: {}
status: {}
```

19 - com uma linha de comando escale um deploy chamado `basico` no namespace `azul` para 10 replicas.

```bash
k scale deploy basico -n azul --replicas 10
```

20 - com uma linha de comando, crie um autoscale de cpu com 90% de no minimo 2 e maximo de 5 pods para o deploy `site` no namespace `frontend`.

```bash
kubectl autoscale deploy site -n frontend --cpu-percent=90 --min=2 --max=5
```

21 - com uma linha de comando, descubra o conteudo da secret `piadas` no namespace `meussegredos` com a entrada `segredos`.

```bash
k get secret piadas -n meussegredos -o jsonpath="{.data.segredos}" | base64 --decode; echo
```

22 - marque o node o nó `k8s-worker1` do cluster para que nao aceite nenhum novo pod.

```bash
k cordon k8s-worker1
```

23 - esvazie totalmente e de uma unica vez esse mesmo nó com uma linha de comando.

```bash
k drain k8s-worker1 --ignore-daemonsets
```

24 - qual a maneira de garantir a criaçao de um pod ( sem usar o kubectl ou api do k8s ) em um nó especifico.

```
Criando um pod estático, com o manifesto static-<POD_NAME>.yaml e salvando o arquivo em /etc/kubernetes/manifests (default), ou no diretório especificado na diretiva **staticPodPath** nas configurações do kubelet.
```

25 - criar uma serviceaccount `userx` no namespace `developer`. essa serviceaccount só pode ter permissao total sobre pods (inclusive logs) e deployments no namespace `developer`. descreva o processo para validar o acesso ao namespace do jeito que achar melhor.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: developer
spec: {}
status: {}

---

apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: null
  name: userx
  namespace: developer

---

apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  creationTimestamp: null
  name: userx-role
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - pods/log
  verbs:
  - get
  - list
  - watch
  - create
  - patch
  - update
  - delete
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - get
  - list
  - watch
  - create
  - patch
  - update
  - delete

---

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  creationTimestamp: null
  name: userx-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: userx-role
subjects:
- kind: ServiceAccount
  name: userx
  namespace: developer
```

26 - criar a key e certificado cliente para uma usuaria chamada `jane` e que tenha permissao somente de listar pods no namespace `frontend`. liste os comandos utilizados.

```
openssl genrsa -out jane.key 2048

openssl req -new -key jane.key -subj "/CN=jane" -out jane.csr

cat jane.csr | base64 | tr -d "\n"
```
```bash
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: jane
spec:
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZEQ0NBVHdDQVFBd0R6RU5NQXNHQTFVRUF3d0VhbUZ1WlRDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRApnZ0VQQURDQ0FRb0NnZ0VCQUxrWm8vNG1hZWc1UEl1ektod2NHWDh1aEhRV1lMeCtzS1hmaUpjeWhUbFhuclBPCnMxREUwUnkyQVY5cGkvelRWdkxOTFVVK3pkMmhvQTQ2RHMvOFdDL0g0RTkwQ0R2TDZ3OVhzdi9nRFVxaTNmRnUKUlN1VEFBU01ndE5qK0VxeUhHd3JKQ3FMT3p0QXdyY291QmlQTU9XcXpZTUhOMkwrV3R5YUlCdnBtVjYvMjNUOApmVW14akVhcm9qRG9kbjJBTitDWmFaZUpNVlJyVHF1YVVFUXY1Vk5jMWk2N2NocklidGtMdnZEY2N1TGhpUGlqCi8xVnhjcG5adFV2UEJzRHY0WG5iNHJvT29pMlFVMWJsaXZpS0hncEJEZnViQk1nRmlQQko1ZHdmSkFtMmhKRzgKd2x2L3ZxZDF6clpObUdPWHR2cTVtdnJIakRTZXZTb0ZUZ05nVktFQ0F3RUFBYUFBTUEwR0NTcUdTSWIzRFFFQgpDd1VBQTRJQkFRQVNUMWVQQ0krSVJEVHdFdzhaY1dkRjYrN2dmUWU3b29IWDJESk5qNm9XNllKNFA3c21iTmx5Ci80NklGOTh6ckZXc0tldjVzd0dUSzJ4YjM3S2Y3eHRWY2VwWisrTDNlelFLZVVWUGliZVRnWkUvWUpMWk9Hc0oKZ2tiWDZsSmQxazZkcU9zWm1DcEEzdDZOTDVtaTlyK3BZMjdxZ2hVMzJWa1BOSE1hWXNxdzdvcnhmaTVXa0FtNQp4VGh3bWFCVzQyRFJxYm9Qd2FQTGFOZzQ0cGZtQzdDdWNTNnF2WjJZMEhvOVh3YWZxZWFwMXcyWXhHbUlLckMrCmw3OFBGcUxRS2dZZldLejlQRHBQZW12YmJvanhFZlMyRWJJRTFFcjY5VXFhVDVQNVZMa1FtdlRSS1FoanFiREgKNG11dzZMekVYazJ2OHNtNEZRT2VCQ3QrZ3FkVkZtMHkKLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==
EOF
```
```
kubectl certificate approve jane

k create role jane-role --resource=pods --verb=list

k create rolebinding jane-role-binding -n frontend --user=jane --role=jane-role

kubectl config set-credentials myuser --client-key=myuser.key --client-certificate=myuser.crt --embed-certs=true

kubectl config set-context myuser --cluster=kubernetes --user=myuser
```

27 - qual o `kubectl get` que traz o status do scheduler, controller-manager e etcd ao mesmo tempo

```bash
k get po -n kube-system ou k get po -A
```