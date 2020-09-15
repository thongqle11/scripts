#!/bin/bash
clear

echo "(1)Port or (2)Ports"
read Num_Ports

if [ $Num_Ports == 1 ]; then
	echo "Enter NIC interface (ex. eth4)"
	read NIC1
	echo "Enter time down in seconds."
	read TIMEDOWN
	echo "Enter time up in seconds."
	read TIMEUP
	echo "Enter test IP address to ping from $NIC1."
	read TESTIP1
       
	while true;do
        	echo "$(date +"%D %T")  Bringing down $NIC1"
        	logger "**** Bringing down $NIC1 ****"
        	ifconfig $NIC1 down > /dev/null
        	sleep $TIMEDOWN
        	echo "$(date +"%D %T")  Bringing up $NIC1"
        	logger "**** Bringing up $NIC1 ****"
        	ifconfig $NIC1 up > /dev/null
        	sleep 25
        	echo "$(date +"%D %T")  Pinging $TESTIP1"
	
		#Test for IP connectivity
        	if ping -c 1 $TESTIP1 | grep -Fq "1 received"
        		then
                echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 PASSED"
        		else
                echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 FAILED"
                exit
        	fi
	        sleep $TIMEUP
	done

elif  [ $Num_Ports == 2 ]; then
	echo "Enter first NIC interface (ex. eth4)"
	read NIC1
	echo "Enter second NIC interface (ex. eth5)"
	read NIC2
	echo "Enter time down in seconds."
	read TIMEDOWN
	echo "Enter time up in seconds."
	read TIMEUP
	echo "Enter test IP address to ping from $NIC1."
	read TESTIP1
	echo "Enter test IP address to ping from $NIC2."
	read TESTIP2

	while true;do
		echo "$(date +"%D %T")  Bringing down $NIC1"
        	logger "**** Bringing down $NIC1 ****"
		ifconfig $NIC1 down > /dev/null
		sleep $TIMEDOWN
		echo "$(date +"%D %T")  Bringing up $NIC1"
        	logger "**** Bringing up $NIC1 ****"
		ifconfig $NIC1 up > /dev/null
		sleep 25
		echo "$(date +"%D %T")  Pinging $TESTIP1"
		
		#Test for IP connectivity	
		if ping -c 1 $TESTIP1 | grep -Fq "1 received"
        		then
		echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 PASSED"
        		else
		echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 FAILED"
		exit
        	fi
		sleep $TIMEUP

		echo "$(date +"%D %T")  Bringing down $NIC2"
        	logger "**** Bringing down $NIC2 ****"
		ifconfig $NIC2 down > /dev/null
		sleep $TIMEDOWN
		echo "$(date +"%D %T")  Bringing up $NIC2"
        	logger "**** Bringing up $NIC2 ****"
		ifconfig $NIC2 up > /dev/null
		sleep 25
		echo "$(date +"%D %T")  Pinging $TESTIP2"
	
		#Test for IP connectivity	
		if ping -c 1 $TESTIP2 | grep -Fq "1 received"
        		then
		echo "$(date +"%D %T")  IP connectivity test to $TESTIP2 PASSED"
        		else
		echo "$(date +"%D %T")  IP connectivity test to $TESTIP2 FAILED"
		exit
		fi
		sleep $TIMEUP
	done
else
	echo "Bad parameter."
fi
