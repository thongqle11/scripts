#!/bin/bash

echo "Going to find biggest lun in multipath -ll output"
biglun=$(cat testfile | grep '^size=' | awk '{print $1}' | cut -d= -f2 | sort -n | tail -1)
echo "The biggest lun detected is $biglun"
break
multipath -ll |less
echo /$biglun
