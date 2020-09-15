#!/bin/bash


host=21002c27d752ba9f
for i in $(cat maps | awk '{print $1}'); do
echo "sendln 'unmap volume host $host $i'"
lun=$((lun+1))
done
