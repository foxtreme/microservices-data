#!/bin/bash
# Se recibira el nombre del archivo a procesar como argumento de este script
ARCHIVO="/usr/local/data/terminado.txt"
while [ ! -f "${ARCHIVO}" ]; do
  sleep 2
done
echo "Eliminando signos de interrogacion"
sed -i.bak "s/, ?,/,,/g" $1
rm "${ARCHIVO}"
