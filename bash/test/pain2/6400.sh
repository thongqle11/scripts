#!/bin/sh
for i in $(multipath -ll | grep "dm-" | grep HSV400 | awk '{print $3}'); do
echo "/dev/"$i
done
