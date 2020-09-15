#!/bin/sh
for i in $(multipath -ll | grep "dm-" | grep HSV300 | awk '{print $3}'); do
echo "/dev/"$i
done
