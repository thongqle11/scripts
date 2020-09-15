#!/bin/bash


for i in $(cat maps | awk '{print $2}'); do
echo "sendln 'delete volume $i'"
lun=$((lun+1))
done
