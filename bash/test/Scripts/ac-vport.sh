#!/bin/sh

for i in 0 1 2 3 4 5
do
        for j in 0 1 2 3 4 5 6 7 8 9 a b c d e f
        do
                echo "creating VP 1234567890abcd$i$j:abcdef12345678$i$j"
                echo "1234567890abcd$i$j:abcdef12345678$i$j" > /sys/class/fc_host/host4/vport_create

        done
done


sleep 15


for i in 0 1 2 3 4 5
do
        for j in 0 1 2 3 4 5 6 7 8 9 a b c d e f
        do
                echo "deleting VP 1234567890abcd$i$j:abcdef12345678$i$j"
                echo "1234567890abcd$i$j:abcdef12345678$i$j" > /sys/class/fc_host/host4/vport_delete

        done
done


sleep 30


sh vport.sh

