#!/bin/sh
for i in $(multipath -ll | grep "dm-" | grep MSA23 | awk '{print $3}'); do
echo "/dev/"$i
done
