#!/bin/sh
# To run, pipe script to ssh session of VCM 
# example: ./VC-Failover.sh | ssh Administrator@172.24.102.240


#IO Module Bays Used.  Quitman->1/2, Quintana Mezz1-> 3/4, Quintana Mezz2-> 5/6, Quintana Mezz3-> 7/8
IO_MODULE1=1
IO_MODULE2=2
#Name of SAN Profiles used in IO_MODULES specified above. For iSCSI, substitute with Ethernet Networks used for iSCSI connection.
SAN1=Bay3-Port4-Linux-Cisco
#SAN1=iSCSI-Bay3-x7
SAN2=Bay4-Port4-Linux-Brocade
#SAN2=iSCSI-Bay4-x7

#Name of Server Profile in VCM assigned to blade.
SERVER_PROFILE="TL-Bay4"

time_down=180
time_up=180


while true
do
  (
  sleep 2
  echo set fc-connection $SERVER_PROFILE $IO_MODULE1 Fabric=""
  sleep $time_down
  
  echo set fc-connection $SERVER_PROFILE $IO_MODULE1 Fabric="$SAN1"
  sleep $time_up

  echo set fc-connection $SERVER_PROFILE $IO_MODULE2 Fabric=""
  sleep $time_down
  
  echo set fc-connection $SERVER_PROFILE $IO_MODULE2 Fabric="$SAN2"
  sleep $time_up
  ) 
done
