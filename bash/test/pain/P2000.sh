#!/bin/sh
for i in $(multipath -ll | grep "dm-" | grep P2000 | awk '{print $3}'); do
echo "/dev/"$i
done
