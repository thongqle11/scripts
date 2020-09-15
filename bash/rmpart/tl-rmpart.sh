#!/bin/bash
#Script to wipe all devices except for device(s) specified
#as boot_sd variable, usually boot device
#
#boot_sd=$(multipath -ll | grep -A3 36G | grep sd | awk '{print $3}')
boot_sd=$(multipath -ll | grep -A4 60G | grep sd | grep -o "[s][d][a-z]\{1,2\}")
#Query all sd device in /dev and output to lun-inq
ls /dev/sd* > lun-inq
#if temp file exists, delete before proceeding
if [ -f lun-boot.tmp ]; then
	rm -f lun-boot.tmp
fi
#Create 2 files: (a)lun-inq lists devices to wipe (b)lun-boot.tmp lists devices not to wipe
for i in $boot_sd
do 
	cat lun-inq | grep -v $i$ | grep -v $i"[1-9]"$ > lun-inq.tmp
	cat lun-inq | grep $i"[1-9]"$ >> lun-boot.tmp
	cat lun-inq | grep $i$ >> lun-boot.tmp
	cat lun-inq.tmp > lun-inq
done
echo "***All sd devices in /dev/ except for the following will be wiped:***"
#List only unique boot devices and its partitions
cat lun-boot.tmp | sort | uniq
echo "***Are you sure? Hit Y to continue...***"
read answer
if [[  "$answer" = [Yy] ]] ; then
        for i in `cat lun-inq`
                do
                 dd if=/dev/zero of=$i bs=65536 count=1 2>&1
                done
        echo ""
#cleanup
        rm lun-inq
        rm lun-inq.tmp
        rm lun-boot.tmp
        echo "Deleted temp files"
else
#cleanup
        rm lun-inq
        rm lun-inq.tmp
        rm lun-boot.tmp
	echo "Deleted temp files"
	echo "Exiting..."
        exit
fi
