#!/bin/sh
#This script is using pain and cycle thru all patterns
#with 60 seconds each pattern. The targets.dat can be 
#modified to use with multipath devices (EX: /dev/dm-0,/dev/dm-1,...)
while true
do
	PATH=$PATH:/opt/medusa_labs/test_tools/bin; export PATH
	for i in `cat blocksize.txt | awk '{print $1}'`
	do
		echo "******************************"
		echo "RUNNING BLOCK -b$i"
		echo "******************************"
		echo
		maim -o -u -d60 -Y1 -b$i -M0 -ftargets.dat
		sleep 1
	done
done
