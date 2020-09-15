#!/bin/sh
for i in $(multipath -ll | grep "dm-" | grep EQLOGIC | awk '{print $2}'); do
echo "/dev/"$i
done
