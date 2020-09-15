#!/bin/bash

# Script to run peg_halt_all in loop

cd /aspi/phanmon/hilda/Tcl

i=0
while [ 1 ]
do
echo "COUNT=$i"
logger -d "****** PEG_HALT_ALL ITERATION # COUNT=$i*****"
echo "peg_halt_all" | ./phanmon
sleep 120
((i+=1))
done
