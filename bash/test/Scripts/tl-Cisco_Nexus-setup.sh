#!/bin/sh
#Thong Le 4/8/2013
echo "***************************************"
echo "***************************************"
echo "   SETTING Cisco PORTS"
echo "***************************************"
echo "***************************************"

echo " Please enter the Cisco SWITCH IP "
read SWITCHIP
(
  sleep 2
  echo admin
  sleep 3
  echo Qlogic01
  sleep 2
  echo config t
  sleep 2

#Configure Initiator FCoE Ports
TenGB_Port=1
while [ $TenGB_Port -le 24 ]; do
  echo interface ethernet 1/$TenGB_Port
  sleep 1
  echo priority-flow-control mode auto
  sleep 1
  echo lldp receive
  sleep 1
  echo lldp transmit
  sleep 1
  echo switchport mode trunk
  sleep 1
  echo switchport trunk allowed vlan 1002
  sleep 1
  echo switchport trunk allow vlan add 1
  sleep 1
  echo int vfc $TenGB_Port
  sleep 1
  echo no shut
  sleep 1
  echo bind interface ethernet 1/$TenGB_Port
  sleep 1
  echo vlan 1002
  sleep 1
  echo fcoe vsan 1
  sleep 1
  echo exit
  sleep 1
  echo vsan database
  sleep 1
  echo vsan 1
  sleep 1
  echo vsan 1 interface vfc $TenGB_Port
  sleep 1
  echo exit
  sleep 1
  echo int ethernet 1/$TenGB_Port
  sleep 1
  echo spanning-tree port type edge trunk
  sleep 1
  echo shut
  sleep 1
  echo no shut
  sleep 1
  echo exit
  sleep 1
  TenGB_Port=$(( TenGB_Port + 1 ))
done
) | telnet $SWITCHIP
