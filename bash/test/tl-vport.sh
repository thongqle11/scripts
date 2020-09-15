#!/bin/sh
num_vp=2

echo "Enter first host from /sys/class/fc_host/ (i.e. host7):"
read HOST1
echo "Enter second host from /sys/class/fc_host/ (i.e. host8):"
read HOST2
echo "Enter number of seconds between each vport creation/deletion:"
read wait_time
clear

#First Port
vp_suffix=11
i=1
while [ "$i" -le "$num_vp" ]
do
	logger "**** Creating VP $i: 4434567890abcd$vp_suffix:abcdef12345678$vp_suffix on $HOST1 ****"	
	echo "**** Creating VP $i: 4434567890abcd$vp_suffix:abcdef12345678$vp_suffix on $HOST1 ****"	
	echo "4434567890abcd$vp_suffix:abcdef12345678$vp_suffix"  > /sys/class/fc_host/$HOST1/vport_create
	sleep $wait_time
	vp_suffix=$(( $vp_suffix + 1 ))
	i=$(( $i +1 ))
done

vp_suffix=11
i=1
while [ "$i" -le "$num_vp" ]
do
        logger "**** Deleting VP $i: 4434567890abcd$vp_suffix:abcdef12345678$vp_suffix on $HOST1 ****"
        echo "**** Deleting VP $i: 4434567890abcd$vp_suffix:abcdef12345678$vp_suffix on $HOST1 ****"
        echo "4434567890abcd$vp_suffix:abcdef12345678$vp_suffix"  > /sys/class/fc_host/$HOST1/vport_delete
        sleep $wait_time
        vp_suffix=$(( $vp_suffix + 1 ))
        i=$(( $i +1 ))
done

#2nd Port
vp_suffix=11
i=1
while [ "$i" -le "$num_vp" ]
do
        logger "**** Creating VP $i: 4534567890abcd$vp_suffix:abcdef12345678$vp_suffix on $HOST2 ****"
        echo "**** Creating VP $i: 4534567890abcd$vp_suffix:abcdef12345678$vp_suffix on $HOST2 ****"
        echo "4534567890abcd$vp_suffix:abcdef12345678$vp_suffix"  > /sys/class/fc_host/$HOST2/vport_create
        sleep $wait_time
        vp_suffix=$(( $vp_suffix + 1 ))
        i=$(( $i +1 ))
done

vp_suffix=11
i=1
while [ "$i" -le "$num_vp" ]
do
        logger "**** Deleting VP $i: 4534567890abcd$vp_suffix:abcdef12345678$vp_suffix on $HOST2 ****"
        echo "**** Deleting VP $i: 4534567890abcd$vp_suffix:abcdef12345678$vp_suffix on $HOST2 ****"
        echo "4534567890abcd$vp_suffix:abcdef12345678$vp_suffix"  > /sys/class/fc_host/$HOST2/vport_delete
        sleep $wait_time
        vp_suffix=$(( $vp_suffix + 1 ))
        i=$(( $i +1 ))
done
