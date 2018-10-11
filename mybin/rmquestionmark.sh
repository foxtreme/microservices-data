#!/bin/bash
# Se recibira el nombre del archivo a procesar como argumento de este script
sed -i.bak "s/, ?,/,,/g" $1
