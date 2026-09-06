# Relatorio da aula 2

03/09/2026 - lab 03

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
