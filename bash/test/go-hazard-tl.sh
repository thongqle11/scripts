#!/bin/bash

HOSTS=""
DIR=/disk2/hazard-700.03.16/
c16_OPTIONS="-s! -n -c16 -t24 -A2 -D2 -o test==diskfs?sync=3 -o test==diskbdr?bdr=1 -o test==diskbdr?timesleepM=3600"
c15_OPTIONS="-s! -n -c15 -t24 -A2 -D2" 
c8_OPTIONS="-s! -n -c8 -t72"
HAZHOME=/disk2/hazard-700.03.16





#############################
#This creates the argument for the f/s on each host
for i in $HOSTS; do
        z="-o ip==$i?fstype=ext3"
        HOST_OPTIONS=$HOST_OPTIONS" "$z
done
##############################
if [ "$1" == "1" ]; then
    echo "Running IO Phase: $HAZHOME/hazard -I -L -v -d $DIR $HOSTS"
     $HAZHOME/hazard -I -L -v -d $DIR $HOSTS
elif [ "$1" == "2" ]; then
    echo "Running Scan Phase:  $HAZHOME/hazard -i -S -d $DIR $HOSTS"
     $HAZHOME/hazard -i -S -d $DIR $HOSTS
elif [ "$1" == "c8" ]; then
    echo "Starting c8:  $HAZHOME/hazard $c8_OPTIONS $HOST_OPTIONS -d $DIR $HOSTS"
     $HAZHOME/hazard $c8_OPTIONS $HOST_OPTIONS -d $DIR $HOSTS
elif [ "$1" == "c16" ]; then
    echo "Starting c16:  $HAZHOME/hazard $c16_OPTIONS $HOST_OPTIONS -d $DIR $HOSTS"
     $HAZHOME/hazard $c16_OPTIONS $HOST_OPTIONS -d $DIR $HOSTS
elif [ "$1" == "c15" ]; then
    echo "Starting c15:  $HAZHOME/hazard $c15_OPTIONS $HOST_OPTIONS -d $DIR $HOSTS"
     $HAZHOME/hazard $c15_OPTIONS $HOST_OPTIONS -d $DIR $HOSTS
elif [ "$1" == "-h" ]; then
    echo "USAGE: go-hazard-tl.sh 1|2|c8|c15|c16"
    echo "     1: IO Phase"
    echo "     2: SCAN Phase"
    echo "     c8: Start c8 test"
    echo "     c15: Start c15 test"
    echo "     c16: Start c16 test"
    exit
else
    echo "ERROR: Invalid Argument"
    echo "USAGE: go-hazard-tl.sh 1|2|c8|c15|c16"
    echo "     1: IO Phase"
    echo "     2: SCAN Phase"
    echo "     c8: Start c8 test"
    echo "     c15: Start c15 test"
    echo "     c16: Start c16 test"
    exit
fi
