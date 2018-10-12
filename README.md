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

`docker-compose` es una herramienta que permite ejecutar varios contenedores con un solo comando. 
En este caso queremos ejecutar nuestro primer contenedor el cual descarga un archivo de datos y luego elimina los datos `, ?,`. 

El archivo que materializa esta ejecucion es `docker-compose.yml`.

```
version: "3"
services:
  download:
    image: josanabr/mycurl
    volumes:
      - ./data:/usr/local/data
      - ./mybin:/usr/local/mybin
    command: /usr/local/mybin/adult.data.sh
  rmquestionmark:
    image: ubuntu
    volumes:
      - ./data:/usr/local/data
      - ./mybin:/usr/local/mybin
    command: /usr/local/mybin/rmquestionmark.sh adult.data
```

Sin embargo, esta ejecucion tiene un problema y es que `docker-compose` ejecuta los dos contenedores en **paralelo** y en este caso queremos una ejecucion **secuencial**, primero el contenedor `josanabr/mycurl` y luego el contenedor `ubuntu`.

Para lograr esta ejecucion secuencial se hizo una modificacion en los scripts de modo que `adult.data.sh` al terminar su ejecucion cree un archivo llamado `terminado.txt` y la creacion de ese archivo es la senal para que `rmquestionmark.sh` comience a procesar el archivo descargado.

Aqui la implementacion, `adult.data.sh`

```
#!/bin/bash
PREFIXDIR="/usr/local/data"
cd ${PREFIXDIR}
curl http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data > ${PREFIXDIR}/adult.data
echo "Creando archivo $(pwd)/terminado.txt"
touch terminado.txt
```

Observe que al final se crea el archivo `/usr/local/data/terminado.txt`. 
Ahora la nueva implementacion de `rmquestionmark.sh`

```
#!/bin/bash
# Se recibira el nombre del archivo a procesar como argumento de este script
ARCHIVO="/usr/local/data/terminado.txt"
while [ ! -f "${ARCHIVO}" ]; do
  sleep 2
done
echo "Eliminando signos de interrogacion"
sed -i.bak "s/, ?,/,,/g" $1
rm "${ARCHIVO}"
```

Para probar la ejecucion ejecute desde una terminal `docker-compose up`.

---

Se quiere procesar un campo de los que tiene el CSV, ese campo lo selecciona usted. 
Genere un script que procese ese campo y arroje en un archivo plano el valor **maximo**, **minimo**, **mediana**.
Identifique la ejecucion que permitira que a traves de un contenedor se pueda ejecutar su script.
Haga los ajustes necesarios en:

* [`docker-compose.yml`](docker-compose.yml)
* [`rmquestionmark.sh`](mybin/rmquestionmark.sh)

de modo que su script se convierta en la tercera etapa de procesamiento de los datos en `adult.data`.

---

Se le pide que haga un ejercicio similar al anterior pero con esta fuente de datos [Crime Data from 2010 to Present](https://catalog.data.gov/dataset/crime-data-from-2010-to-present). 
Estos datos son tomados de [este sitio](https://catalog.data.gov/dataset?tags=crime).

Los items a programar son:

* Descargar los datos via un contenedor
* Preparación de los datos
  * En el archivo descargado se observa que algunos campos tienen dentro de su valor el caracter `,`
  * Este [script](processCSV.py) en Python el cual espera recibir como un flujo de entrada los datos de un archivo CSV y arroja por pantalla el nuevo archivo CSV pero cambia el delimitador `,` por `|`
  * Se ha provisto de un [script en Bash](processCSV.sh) que recibe tres argumentos
    * Un directorio que esta compartido entre el *host* y el contenedor
    * Un archivo CSV al que se le desea cambiar su delimitador
    * Un archivo donde residira el nuevo CSV con el nuevo delimitador
  * Con el script en Bash usted pondra invocar su contenedor para ejecutar el archivo indicandole los argumentos que requiere para su correcta ejecucion
* Sacar el promedio de uno de los datos bajo estudio
