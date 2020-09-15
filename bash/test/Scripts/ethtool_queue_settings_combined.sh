#!/bin/sh
echo "(1)Port or (2)Ports"
read Num_Ports

if [ $Num_Ports == 1 ]; then
	echo "Enter 1st interface"
	read interface1
	while true; do
		for i in 2 4 6 8 10 12 14 16; do
       			echo "Changing parameter of $interface1 to $i"
        		ethtool -L $interface1 combined $i
        		sleep 10
		done
	done

elif [ $Num_Ports == 2 ]; then
	echo "Enter 1st interface"
	read interface1
	echo "Enter 2nd interface"
	read interface2
	while true; do
		for i in 2 4 6 8 10 12 14 16; do
        		echo "Changing parameter of $interface1 to $i"
        		ethtool -L $interface1 combined $i
        		sleep 10

        		echo "Changing parameter of $interface2 to $i"
        		ethtool -L $interface2 combined $i
        		sleep 10
		done
	done

else
        echo "Bad parameter."
fi
