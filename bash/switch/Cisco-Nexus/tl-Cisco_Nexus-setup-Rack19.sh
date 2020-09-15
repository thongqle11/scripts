#!/bin/sh
#Thong Le 4/8/2013

vlan_id=11
vsan_id=11
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
  echo feature fcoe
  sleep 2
  echo vlan $vlan_id
  sleep 2
  echo fcoe vsan $vsan_id
  sleep 2  
  echo service unsupported-transceiver
  sleep 2
  echo system qos
  sleep 2
  echo service-policy type qos input fcoe-default-in-policy
  sleep 2
  echo service-policy type queuing input fcoe-default-in-policy
  sleep 2
  echo service-policy type queuing output fcoe-default-out-policy
  sleep 2
  echo service-policy type network-qos fcoe-default-nq-policy
  sleep 2
  echo control-plane
  sleep 2
  echo service-policy input copp-system-policy-customized
  sleep 2

#Configure Initiator FCoE Ports
TenGB_Port=1
while [ $TenGB_Port -le 32 ]; do
  echo default interface ethernet 1/$TenGB_Port
  sleep 1 
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
  echo switchport trunk allowed vlan 1,$vlan_id
  sleep 1
  echo int vfc $TenGB_Port
  sleep 1
  echo no shut
  sleep 1
  echo bind interface ethernet 1/$TenGB_Port
  sleep 1
  echo vlan $vlan_id
  sleep 1
  echo fcoe vsan $vsan_id
  sleep 1
  echo exit
  sleep 1
  echo vsan database
  sleep 1
  echo vsan $vsan_id
  sleep 1
  echo vsan $vsan_id interface vfc $TenGB_Port
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
  sleep 2
  echo copy running-config startup-config
) | telnet $SWITCHIP
