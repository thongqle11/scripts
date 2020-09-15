#!/bin/bash

clear
echo "***************************************************************************"
echo "** Please make sure all agents (qlremote, iqlremote and netqlremote) are **"
echo "** stopped before continuing ...                                         **"
echo "***************************************************************************"
echo
echo "Please enter the name of the NIC interface used by qlcnic driver"
echo "(i.e. eth4):"
read eth_interface
if  ifconfig -a | grep -Fq "$eth_interface"
then
	:	
else
	echo "Interface not found... Exiting"
	exit
fi

echo
echo "Please enter the name of the driver under test (i.e. qlcnic, qlge):"
read driver_name

echo "Please enter the test IP address:"
read test_ip

unload_status=`lsmod | grep -c $driver_name`
if [ $unload_status -lt 1 ]
then
	echo
	echo "Driver not installed or loaded. Please make sure the driver is loaded prior to starting the test.....Exiting"
	echo
	exit
fi

multipath -F
service multipathd stop > /dev/null
clear
echo "Test Starting . . . . "
sleep 5

#trap "modprobe $driver_name > /dev/null;service multipathd start > /dev/null; exit 1" 2

counter=0
pass_count=0
fail_count=0

while true
do
	clear
	echo "********************************"
	echo " Iterations Completed: $counter"
	echo " Iterations Passed:    $pass_count"
	echo " Iterations Failed:    $fail_count"
	echo " Current Task: Unloading $driver_name"
	echo "********************************"

	rmmod $driver_name
	sleep 5
	unload_status=`lsmod | grep -c $driver_name`
	if [ $unload_status != 0 ]
	then
		echo
		echo "Driver failed to unload.....Exiting"
	#	service multipathd start > /dev/null
		echo
		exit
	fi

	sleep 60

	clear
	echo "******************************"
	echo " Iterations Completed: $counter"
	echo " Iterations Passed:    $pass_count"
	echo " Iterations Failed:    $fail_count"
	echo " Current Task: Loading $driver_name"
	echo "******************************"

	modprobe $driver_name
	sleep 60

	clear
	echo "*****************************"
	echo " Iterations Completed: $counter"
	echo " Iterations Passed:    $pass_count"
	echo " Iterations Failed:    $fail_count"
	echo " Current Task: Checking for NIC interface"
	echo "*****************************"


if  ifconfig -a | grep -Fq "$eth_interface" &&  ping -c 1 $test_ip | grep -Fq "1 received"
	then
		pass_count=$((pass_count+1))
	else
		fail_count=$((fail_count+1))
	fi

	counter=$((counter+1))

	sleep 5
done
