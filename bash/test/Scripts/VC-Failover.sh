#!/bin/sh
# To run, pipe script to ssh session of VCM 
# example: ./VC_Failover.sh | ssh Administrator@172.24.102.240

#Protocol being tested. Uncomment the one being tested.
#PROTOCOL=fcoe
PROTOCOL=iscsi

#IO Module Bays Used.  Quitman->1/2, Quintana Mezz1-> 3/4, Quintana Mezz2-> 5/6, Quintana Mezz3-> 7/8
IO_MODULE1=3
IO_MODULE2=4
#Name of SAN Profiles used in IO_MODULES specified above. For iSCSI, substitute with Ethernet Networks used for iSCSI connection.
SAN1=iSCSI-Bay3-x7
SAN2=iSCSI-Bay4-x7
#Name of Server Profile in VCM assigned to blade.
SERVER_PROFILE=BAY_14_iSCSI

time_down=120
time_up=60

if [ "$PROTOCOL" = fcoe ]; then
	TYPE=Fabric
elif [ "$PROTOCOL" = iscsi ]; then
	TYPE=Network
else
	echo "ERROR: Check Test Type, FCoE or iSCSI"
	exit
fi

while true
do
  (
  sleep 2
  echo set $PROTOCOL-connection $SERVER_PROFILE:$IO_MODULE1 $TYPE=""
  sleep $time_down
  
  echo set $PROTOCOL-connection $SERVER_PROFILE:$IO_MODULE1 $TYPE="$SAN1"
  sleep $time_up

  echo set $PROTOCOL-connection $SERVER_PROFILE:$IO_MODULE2 $TYPE=""
  sleep $time_down
  
  echo set $PROTOCOL-connection $SERVER_PROFILE:$IO_MODULE2 $TYPE="$SAN2"
  sleep $time_up
  ) 
done
