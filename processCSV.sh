#!/bin/bash
head $1/$2 | python3 $1/processCSV.py > $1/$3
