#!/usr/bin/env python3
#
# Esta funcion en Python permite dado un archivo CSV que tiene dentro de los 
# valores de sus campos una coma (",") el ignorar esa campo en el valor y
# se reemplaza el separador por el simbolo "|"
#
# Webgrafia
# - https://anenadic.github.io/2014-11-10-manchester/novice/python/06-cmdline-non-interactive.html
#
# Author: John Sanabria
# Date: 13-09-2018
#
import csv
import signal
import sys
from io import StringIO

def signal_handler(sig, frame):
        sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
try:
    for line in sys.stdin:
        buff = StringIO(line)
        linereader = csv.reader(buff, delimiter=',', quotechar='"')
        for row in linereader:
            for i in row:
                print("%s|"%i, end=''),
            print("") 
    pass
except IOError:
    sys.exit(4)
    pass
