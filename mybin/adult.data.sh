#!/bin/bash
PREFIXDIR="/usr/local/data"
cd ${PREFIXDIR}
curl http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data > ${PREFIXDIR}/adult.data
echo "Creando archivo $(pwd)/terminado.txt"
touch terminado.txt
