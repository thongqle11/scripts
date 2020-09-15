#!/bin/bash


lun=1
host=2100000e1e16dc00
for i in $(cat maps | awk '{print $1}'); do
#lun=$(cat maps | awk '{print $3}')
#echo "sendln 'map volume access rw lun $lun host $host $i'"
echo "sendln 'map volume access rw lun $lun host $host $i'"
#echo "sendln 'sleep 1'"
lun=$((lun+1))
done
