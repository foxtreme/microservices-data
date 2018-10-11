#!/bin/bash
PREFIXDIR="/usr/local/data"
# Nos ubicamos en el directorio ${PREFIXDIR}
cd ${PREFIXDIR}
# Descargando archivo
curl http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data > ${PREFIXDIR}/adult.data
# Este archivo hace las veces de semaforo, al crearse da luz verde
echo "Creando archivo $(pwd)/terminado.txt"
touch terminado.txt
