#!/bin/bash

# Script to run echo 131676 in loop
num_paths=`multipath -ll|grep -c "active ready"`
clear

echo "Please enter the the first host (i.e. host7):"
read HOST1

echo "Please enter the the second host (i.e. host8):"
read HOST2

echo "Please enter the the number of seconds between iterations:"
read TIMEOUT

clear

i=1
while true
do
	current_paths=0
	echo "$(date +"%D %T")  Performing echo 131676 > /sys/class/scsi_host/$HOST1/device/reset - Iteration: $i"
	logger -d "**** Performing echo 131676 > /sys/class/scsi_host/$HOST1/device/reset - Iteration: $i ****"
	echo 131676 > /sys/class/scsi_host/$HOST1/device/reset
	sleep $TIMEOUT
	current_paths=`multipath -ll|grep -c "active ready"`
	if [ $num_paths != $current_paths ]
	then
		echo "Paths Lost. Test Exiting...."
		exit
	fi

        current_paths=0
        echo "$(date +"%D %T")  Performing echo 131676 > /sys/class/scsi_host/$HOST2/device/reset - Iteration: $i"
        logger -d "**** Performing echo 131676 > /sys/class/scsi_host/$HOST2/device/reset - Iteration: $i ****"
        echo 131676 > /sys/class/scsi_host/$HOST2/device/reset
        sleep $TIMEOUT
        ((i+=1))
        current_paths=`multipath -ll|grep -c "active ready"`
        if [ $num_paths != $current_paths ]
        then
                echo "Paths Lost. Test Exiting...."
                exit
        fi

done
