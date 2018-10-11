# Contenedor con curl instalado

Este Dockerfile permite la creacion de una imagen de Docker y se ha personalizado tambien el *prompt* del shell.

```
FROM ubuntu
RUN apt-get update && apt-get install -y curl
COPY bashrc /root/.bashrc
```

Aqui el [Dockerfile](Dockerfile) y el [bashrc](bashrc).

Para ejecutar este contenedor de modo que los directorios `data` y `mybin` en este directorio se puedan ver desde el contenedor en los directorios `/usr/local/data` y `/usr/local/bin` se ejecuta de la siguiente manera

```
docker run --rm -it --hostname demo -v $(pwd)/data:/usr/local/data -v $(pwd)/mybin:/usr/local/mybin josanabr/mycurl /bin/bash
```

**CUIDADO** en este caso debe asegurarse de cambiar `josanabr` por su nombre de usuario en Docker Hub.

---

Ahora usted usara su contenedor para descargar el archivo [adult.data](http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data) que vimos en clases pasadas.

* El archivo a descargar debera quedar ubicado en el directorio `$(pwd)/data`
* Se sugiere hacer un script en Bash para ello y ese script es el que usted usara como argumento para ejecutar su imagen de Docker. Es decir, en lugar de usar `/bin/bash` como argumento, usted pasara su script como argumento
  * Cuando ejecute el contenedor ya no necesitara pasar el argumento `--it` pues esta vez no ejecutara de forma interactiva su contenedor sino que lo usara para ejecutar un script en Bash 
  * Asegurese que la salida del comando `curl` vaya a un archivo y que este archivo quede localizado en el directorio `/usr/local/data` del contenedor
