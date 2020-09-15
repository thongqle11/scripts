#!/bin/bash
clear
echo "(1)Port or (2)Ports"
read Num_Ports
while [[ "$CP" != "y" && "$CP" != "n" ]]; do
        echo "Check Ping? (y)es or (no)"
        read CP
        done

if [ $Num_Ports == 1 ]; then
        if [ "$CP" == "y" ]; then
                echo "Enter test IP address to ping from $NIC1."	
                read TESTIP1
		echo $CP
        else
                :
        fi
else
:
fi
