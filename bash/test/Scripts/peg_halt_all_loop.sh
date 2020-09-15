#!/bin/bash

# Script to run peg_halt_all in loop
num_paths=`multipath -ll|grep -c "active ready"`
clear

echo "Please enter the the number of seconds between iterations:"
read TIMEOUT

cd /root/phanmon_64-v2/Tcl/

clear

i=1
while true
do
	echo "$(date +"%D %T")  Performing peg_halt_all - Iteration: $i"
	logger -d "**** Performing peg_halt_all - Iteration: $i ****"
	echo "peg_halt_all" | ./phanmon > /dev/null 2>&1
	sleep $TIMEOUT
	((i+=1))
	current_paths=`multipath -ll|grep -c "active ready"`
	if [ $num_paths != $current_paths ]
	then
		echo "Paths Lost. Test Exiting...."
		exit
	fi
done
