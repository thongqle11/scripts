#!/bin/sh
for i in $(multipath -ll | grep "dm-" | grep Compellent | awk '{print $3}'); do
echo "/dev/"$i
done
