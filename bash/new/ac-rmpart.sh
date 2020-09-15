#!/bin/bash
echo "Are you sure? Hit Y to continue..."
read answer
if [[  "$answer" = [Yy] ]] ; then
        for i in `cat lun-inq`
                do
                dd if=/dev/zero of=$i bs=65536 count=1 2>&1
		echo "Deleted lun-inq file"
		rm lun-inq
                done
else
        echo "Exiting..."
        exit
fi

