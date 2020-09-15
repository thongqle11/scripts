#!/bin/sh
for i in $(multipath -ll | grep "dm-" | awk '{print $3}'); do
echo "/dev/"$i
done
