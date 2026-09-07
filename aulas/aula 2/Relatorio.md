# Relatorio da aula 2

### 03/09/2026 

Para nos introduzir o mundo do docker o professor nos pediu para execultar o comando `docker run hello-world`, apos executamos a gente teve que execultar o `docker --help` e `docker run --help` para compreender como usar a CLI do docker.

com essa introdução feita, nos tivemos que escolher um Servidor Web de nossa escolha, eu escolhir o nginx, pois ja conhecia de outros cantos, mais nunca mexi nele diretamente.

chegeui a montar um container com o docker-composer para o nginx
```yml
    nginx:
        image: nginx:latest # imagen mais recente do nginx
        ports:
        - "8080:80"   # o acesso a rede do conteiner, (tipo uma linkagem de rede)
                      # (porta da minha maquina):(porta dentro do container))
        volumes:
        - ./nginx:/etc/nginx # diretorio conectado do com o container do nginx
```

depois, foi pedido-nos para ler a documentação do Servidor que escolhemos, para montar um Proxy Reverso.

---

### 07/09/2026 - 01:00 

apos longas 4 horas no vscode quebrando bastante a cabeça tentando entender o porque o nginx não estava mostrando o [index.html](./src/index.html) na porta 8080, decobrir que meu erro tava em tentar passar o link externo com o  `proxy_pass` no server do [default.conf.template](./nginx/templates/default.conf.template) e isso acabava por quebrar o server de alguma maneira, mais apois pequisar, perguntar a AIs e ver videos no youtube, descobrir que o jeito certo é por um `return` em seguida do link.

adicionei uma rota api que leva diretamente para uma musica no youtube

![alt text](./../../asserts/image.png)

contudo feito, o resultado foi um pequeno serviço com um html bem basico e uma rota api que redireciona o para um video.

---
### 07/09/2026 - 11:28 

apos acordar hoje e comprir com minhas atividades domesticas, me sugiu uma duvida em relação ao proxy reverso. Sera que o return no location /herestoyou conta com proxy? pesquisei, e percebi que não é, e naverdade terei que montar um serviço em outro e mapealo.

---
### 07/09/2026 - 13:21 

adcionei um container proprio para o proxy_reverso e outro para um serviço que vai ser mapeado.

```yml 
  proxy_reverso:
    container_name: redes-de-computadores-2
    image:  nginx:latest
    ports:
      - "8080:80"
    working_dir: /var/www/html
    volumes:
      - ./proxy_reverso/nginx:/etc/nginx/templates:ro
      - ./proxy_reverso/src:/var/www/html:ro
    command: ["nginx", '-g', 'daemon off;']

  
  herestoyou:
    image:  nginx:latest
    ports:
      - "8081:80"
    working_dir: /var/www/html
    volumes:
      - ./herestoyou/nginx:/etc/nginx/templates:ro
      - ./herestoyou/src:/var/www/html:ro
    command: ["nginx", '-g', 'daemon off;']

    # o `/var/www/html` de cada container contem arquivos diferente, pois tão linkados com volumes diferentes um com o `./herestoyou/src` e o outro com `./proxy_reverso/src`
```

cada um tendo seus arquivos de configuração e um index.html.

quando execultado o ele abre um serviço do proxy em `localhost:8080`, que serve um index.html e uma rota, e quando acessado `localhost:8080/herestoyou-server/` ele internamente acessa o `localhost:8081` (onde estar hospedado o serviço do herestoyou) e retorna o que puder retornar desse dominio, como o novo `index.html` e a rota `localhost:8081/herestoyou/`  que dentro do proxy vira `localhost:8080/herestoyou-server/herestoyou/` que redireciona para um video no youtube.


- herestoyou/ngnix/default.conf.template:

```nginx
    server {
        listen       80;

        location / {
            root /var/www/html;
            index index.html; 
        }

        location /herestoyou
        {
            return https://youtu.be/R4xWbRBLj2I?si=5gpE_lAD6op1TQFb&t=47;
        }
    }
```

- proxy_reverso/ngnix/default.conf.template:

```nginx
    
server {
    listen       80;
    server_name localhost;

    location / {
       root /var/www/html;
       index index.html; 
    }

    location /herestoyou-server/ {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_pass http://herestoyou:80/;
    }
}
```
