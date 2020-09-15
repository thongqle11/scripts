#!/bin/sh
echo "(1)IPv4 or (2)IPv6"
read IPversion
echo "(1)Port or (2)Ports"
read Num_Ports

if [ $IPversion == 1 ] && [ $Num_Ports == 1 ]; then
	echo "test $IPversion $Num_Ports "
	echo "Enter interface (ex. eth3, ens3:"
	read int1
	echo "Enter test IP address to ping from $int1."
        read TESTIP1
	while true; do
  		for MTU in 128 512 1024 1500 2048 9000 9600;do
        		echo "$(date +"%D %T") ifconfig $int1 mtu $MTU"
        		ifconfig $int1 mtu $MTU
        		sleep 60
			
			#Test for IP connectivity
	                if ping -c 1 $TESTIP1 | grep -Fq "1 received"
       	                	then
       			        echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 PASSED"
                       			else
                		echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 FAILED"
                			exit
                	fi

  		done
	done
elif [ $IPversion == 1 ] && [ $Num_Ports == 2 ]; then 
	echo "test $IPversion $Num_Ports "
	echo "Enter first interface (ex. eth3, ens3):"
	read int1
	echo "Enter second interface (ex. eth3, ens3):"
	read int2
	echo "Enter test IP address to ping from $int1."
        read TESTIP1
        echo "Enter test IP address to ping from $int2."
        read TESTIP2
	while true; do
  		for MTU in 128 512 1024 1500 2048 9000 9600;do
        		echo "$(date +"%D %T") ifconfig $int1 mtu $MTU"
        		ifconfig $int1 mtu $MTU
        		sleep 60
        		echo "$(date +"%D %T") ifconfig $int2 mtu $MTU"
        		ifconfig $int2 mtu $MTU
			sleep 20

			#Test for IP connectivity
                        if ping -c 1 $TESTIP1 | grep -Fq "1 received"
                                then
                                echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 PASSED"
                                        else
                                echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 FAILED"
                                        exit
                        fi
                        
			if ping -c 1 $TESTIP2 | grep -Fq "1 received"
                                then
                                echo "$(date +"%D %T")  IP connectivity test to $TESTIP2 PASSED"
                                        else
                                echo "$(date +"%D %T")  IP connectivity test to $TESTIP2 FAILED"
                                        exit
                        fi
		done
	done
elif [ $IPversion == 2 ] && [ $Num_Ports == 1 ]; then
	echo "test $IPversion $Num_Ports "
        echo "Enter first inteface (ex. eth3, ens3):"
        read int1
	echo "Enter test IP address to ping from $int1."
        read TESTIP1
        while true; do
                for MTU in 1280 1500 2048 9000 9600;do
                	echo "$(date +"%D %T") ifconfig $int1 mtu $MTU"
                	ifconfig $int1 mtu $MTU
                	sleep 60

			#Test for IP connectivity
                        if ping -c 1 $TESTIP1 | grep -Fq "1 received"
                                then
                                echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 PASSED"
                                        else
                                echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 FAILED"
                                        exit
                        fi
                done
        done
elif [ $IPversion == 2 ] && [ $Num_Ports == 2 ]; then
	echo "test $IPversion $Num_Ports "
        echo "Enter first interface (ex. eth3, ens3):"
        read int1
        echo "Enter second interface (ex. eth3, ens3:"
        read int2
        read TIMEUP
        echo "Enter test IP address to ping from $int1."
        read TESTIP1
        echo "Enter test IP address to ping from $int2."
        read TESTIP2
        while true; do
                for MTU in 1280 1500 2048 9000 9600;do
                	echo "$(date +"%D %T") ifconfig $int1 mtu $MTU"
                	ifconfig $int1 mtu $MTU
                	sleep 60
                	echo "$(date +"%D %T") ifconfig $int2 mtu $MTU"
                	ifconfig $int2 mtu $MTU
			sleep 20

			#Test for IP connectivity
                        if ping -c 1 $TESTIP1 | grep -Fq "1 received"
                                then
                                echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 PASSED"
                                        else
                                echo "$(date +"%D %T")  IP connectivity test to $TESTIP1 FAILED"
                                        exit
                        fi

                        if ping -c 1 $TESTIP2 | grep -Fq "1 received"
                                then
                                echo "$(date +"%D %T")  IP connectivity test to $TESTIP2 PASSED"
                                        else
                                echo "$(date +"%D %T")  IP connectivity test to $TESTIP2 FAILED"
                                        exit
                        fi

                done
        done
else
	echo "Bad parameter."
fi
