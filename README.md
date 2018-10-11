# Contenedor con curl instalado

Este Dockerfile permite la creacion de una imagen de Docker y se ha personalizado tambien el *prompt* del shell.

```
FROM ubuntu
RUN apt-get update && apt-get install -y curl
COPY bashrc /root/.bashrc
```

Aqui el [Dockerfile](Dockerfile) y el [bashrc](bashrc).

Como ejecutar un contenedor de modo que los directorios `data` y `mybin` en este directorio se puedan ver desde el contenedor en los directorios `/usr/local/data` y `/usr/local/bin`, respectivamente?

