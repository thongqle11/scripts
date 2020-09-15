#!/bin/sh

i=0
while [ 1 ]
do
logger -s AC:Driver loading qla2xxx $i 
modprobe -v qla2xxx
echo "Driver version:" ; 
cat /sys/module/qla2xxx/version
sleep 10
logger -s AC:Driver Unloading qla2xxx $i
sleep 10 
modprobe -rv qla2xxx

logger -s AC:Driver loading qla4xxx $i 
modprobe -v qla4xxx
echo "Driver version:" ; 
cat /sys/module/qla4xxx/version
sleep 10
logger -s AC:Driver Unloading qla4xxx $i
sleep 10 
modprobe -rv qla4xxx

logger -s AC:Driver loading qlcnic $i 
modprobe -v qlcnic
echo "Driver version:" ; 
cat /sys/module/qlcnic/version
sleep 10
logger -s AC:Driver Unloading qlcnic $i
sleep 10 
modprobe -rv qlcnic

i=`expr $i + 1`
 

done 

