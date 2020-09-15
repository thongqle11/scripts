#!/bin/sh
for i in $(multipath -ll | grep "dm-" | grep OPEN | awk '{print $3}'); do
echo "/dev/"$i
done
