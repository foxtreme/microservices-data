# Contenedor con curl instalado

Este Dockerfile permite la creaci√n de una imagen de Docker y se ha personalizado tambi√n el *prompt* del shell.

```
FROM ubuntu
RUN apt-get update && apt-get install -y curl
COPY bashrc /root/.bashrc
```

Aqu√≠el [Dockerfile](Dockerfile) y el [bashrc](bashrc).
