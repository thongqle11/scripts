#!/bin/sh
echo "(1)IPv4 or (2)IPv6"
read IPversion
echo "(1)Port or (2)Ports"
read Num_Ports

if [ $IPversion == 1 ] && [ $Num_Ports == 1 ]; then
	echo "test $IPversion $Num_Ports "
	echo "Enter interface (ex. eth3, ens3:"
	read int1
	while true; do
  		for MTU in 128 512 1024 1500 2048 9000 9600;do
        		echo "ifconfig $int1 mtu $MTU"
        		ifconfig $int1 mtu $MTU
        		sleep 30
  		done
	done
elif [ $IPversion == 1 ] && [ $Num_Ports == 2 ]; then 
	echo "test $IPversion $Num_Ports "
	echo "Enter first interface (ex. eth3, ens3):"
	read int1
	echo "Enter second interface (ex. eth3, ens3):"
	read int2
	while true; do
  		for MTU in 128 512 1024 1500 2048 9000 9600;do
        		echo "ifconfig $int1 mtu $MTU"
        		ifconfig $int1 mtu $MTU
        		sleep 30
        		echo "ifconfig $int2 mtu $MTU"
        		ifconfig $int2 mtu $MTU
		done
	done
elif [ $IPversion == 2 ] && [ $Num_Ports == 1 ]; then
	echo "test $IPversion $Num_Ports "
        echo "Enter first inteface (ex. eth3, ens3):"
        read int1
        while true; do
                for MTU in 1280 1500 2048 9000 9600;do
                	echo "ifconfig $int1 mtu $MTU"
                	ifconfig $int1 mtu $MTU
                	sleep 30
                done
        done
elif [ $IPversion == 2 ] && [ $Num_Ports == 2 ]; then
	echo "test $IPversion $Num_Ports "
        echo "Enter first interface (ex. eth3, ens3):"
        read int1
        echo "Enter second interface (ex. eth3, ens3:"
        read int2
        while true; do
                for MTU in 1280 1500 2048 9000 9600;do
                	echo "ifconfig $int1 mtu $MTU"
                	ifconfig $int1 mtu $MTU
                	sleep 30
                	echo "ifconfig $int2 mtu $MTU"
                	ifconfig $int2 mtu $MTU
                done
        done
else
	echo "Bad parameter."
fi
