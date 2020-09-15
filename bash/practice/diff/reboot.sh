#!/bin/bash

lspci -vv | grep -A30 "04:00.1 Ethernet controller" | grep "LnkSta" > file2
diff file1 file2
if[ $? -eq 1 ]
then
    echo "pci speeds match...rebooting"
    cp file2 file1 
    sleep 300
    reboot
else
    echo "pci speeds don't match"
    diff file1 file2 > file3
    echo "check file3 for differences":
fi 
