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

Se ha creado un script en Bash llamado [adult.data.sh](mybin/adult.data.sh) localizado en el directorio [mybin](mybin) de este repositorio. 
Es importante que este script tenga permisos de ejecucion. 

El contenido del script es el siguiente

```
#!/bin/bash
cd /usr/local/data
curl http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data > /usr/local/data/adult.data
```

La forma como se ejecuta entonces el contenedor para ejecutar el script es 

```
docker run --rm -v $(pwd)/mybin:/usr/local/mybin -v $(pwd)/data:/usr/local/data josanabr/mycurl /usr/local/mybin/adult.data.sh
```

Una vez ejecutado este comando, usted debera encontrar en el directorio `$(pwd)/data` el archivo `adult.data`.

---

Suponga ahora que usted tiene otro contenedor donde se procesan los datos.
De acuerdo a como lo sugieren las [diapositivas de la clase](https://docs.google.com/presentation/d/1l0WVWwXJE4K2kDnH-3q1e819doAnW8sneF40s7k78yo/edit?usp=sharing) la linea de comandos que quita `, ?,` es `sed -i .bak "s/, ?,/,,/g" adult.data`.
Esta linea la metemos en un script que llamaremos [rmquestionmark.sh](./mybin/rmquestionmark.sh).
Este es el contenido:

```
#!/bin/bash
# Se recibira el nombre del archivo a procesar como argumento de este script
sed -i .bak "s/, ?,/,,/g" $1
```

Nuestro script se puede ejecutar por cualquier contenedor que tenga el shell Bash.
De modo que la forma como se procesa el archivo es de la siguiente manera.

```
docker run --rm -v $(pwd)/mybin:/usr/local/mybin -v $(pwd)/data:/usr/local/data ubuntu /usr/local/mybin/rmquestionmark.sh /usr/local/data/adult.data
```

---

Como podemos crear una linea de ejecucion de estos contenedores para que funcione con un solo comando?
