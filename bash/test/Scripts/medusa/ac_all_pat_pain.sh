#!/bin/sh
while true
do
PATH=$PATH:/opt/medusa_labs/test_tools/bin; export PATH
for i in `cat datapatterns.txt | awk '{print $1}'`
do
echo ******************************
echo "RUNNING PATTERN -l$i -j1"
echo ******************************
echo
pain -o -u -d60 -b256k 512k -l$i -M0 -ftargets.dat
done
done
