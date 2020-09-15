#!/bin/sh
clear
echo "Enter name of inteface:"
read int1

	while true; do
  	  for MTU in 128 512 1024 1500 2048 9000 9600;do
            echo "$(date) : ifconfig $int1 mtu $MTU"
            echo "$(date) : ifconfig $int1 mtu $MTU" >> /var/log/messages
            ifconfig $int1 mtu $MTU
	    sleep 5
	  done
	done
