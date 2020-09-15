#!/bin/bash
echo "***Are you sure? Hit Y to continue...***"
read answer
if [[  "$answer" = [Yy] ]] ; then
        for i in `cat lun-inq`
                do
       	         dd if=/dev/zero of=$i bs=65536 count=1 2>&1
                done
        echo ""
        rm lun-inq
	echo "Deleted lun-inq file"
else
        echo "Exiting..."
        exit
fi

