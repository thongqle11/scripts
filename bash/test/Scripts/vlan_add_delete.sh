#!/bin/sh
clear
echo "Enter name of inteface:"
read int1

echo "Enter VLAN ID to add delete:" 
read vlan

echo "Enter IP you want assigned to $int1:"
read src_ip

echo "Enter IP to send pings to:"
read test_ip

clear
    echo "************Start of Test**************"
    while true; do
        echo "$(date) : vconfig add $int1 $vlan"
        vconfig add $int1 $vlan &>/dev/null
	sleep 3
	
	if [ "$1" = "ipv6" ];then
           ifconfig $int1.$vlan up 
	   sleep 5
	   echo "$(date) : ping6 -I $int1.$vlan -c 3 $test_ip" 
	   if ping6 -I $int1.$vlan -c 3 $test_ip | grep -Fq "3 received"
             then
                echo "$(date) : IP connectivity test to $test_ip PASSED"
           else
                echo "$(date) : IP connectivity test to $test_ip FAILED"
                exit
           fi
 
	else
           ifconfig $int1.$vlan $src_ip up 
	   sleep 5
	   echo "$(date) : ping -c 3 $test_ip"
	   if ping -c 3 $test_ip | grep -Fq "3 received"
             then
                echo "$(date) : IP connectivity test to $test_ip PASSED"
           else
                echo "$(date) : IP connectivity test to $test_ip FAILED"
                exit
           fi
	fi
	
	sleep 5

	#Delete vlan
	echo "$(date) : vconfig rem $int1.$vlan "
        vconfig rem $int1.$vlan &>/dev/null
        sleep 10

     done

