#!/bin/sh
#Thong Le 4/8/2013
echo "***************************************"
echo "***************************************"
echo "   SETTING H3C / Condor PORTS*"
echo "***************************************"
echo "***************************************"

echo " Please enter the H3C SWITCH IP "
read SWITCHIP
(
  sleep 2
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo system-view
  sleep 2
#Create vlan 1002 for Fibre Channel fabric.
echo vlan 1002
sleep 1
#Enable LLDP function.
echo lldp enable
sleep 1
#Enable APP function.
echo acl number 4000
sleep 1
echo rule 0 permit type 8906 ffff
sleep 1
echo rule 1 permit type 8914 ffff
sleep 1
echo traffic classifier fcoe operator or
sleep 1
echo if-match acl 4000
sleep 1
echo traffic behavior fcoe
sleep 1
echo remark dot1p 3
sleep 1
echo qos policy fcoe
sleep 1
echo classifier fcoe behavior fcoe mode dcbx
sleep 1

#Configure Both Condor Modules
Module_Switch=1
while [ $Module_Switch -le 2 ];do
  	Module_Port=1
  	while [ $Module_Port -le 4 ];do
  		echo interface Ten-GigabitEthernet1/$Module_Switch/$Module_Port
  		sleep 1
  		echo port link-type trunk
  		sleep 1
  		echo port trunk permit vlan 1 1002
  		sleep 1
  		echo priority-flow-control auto
  		sleep 1
  		echo priority-flow-control no-drop dot1p 3
  		sleep 1
  		echo qos trust dot1p
  		sleep 1
  		echo lldp tlv-enable dot1-tlv dcbx
  		sleep 1
  		echo quit
  		Module_Port=$(( Module_Port + 1 ))
	done
  		Module_Switch=$(( Module_Switch + 1 ))
  done
#Configure Initiator FCoE Ports
TenGB_Port=1
while [ $TenGB_Port -le 14 ]; do
  echo interface Ten-GigabitEthernet1/0/$TenGB_Port
  sleep 1
  echo port link-type trunk
  sleep 1
  echo port trunk permit vlan 1 1002
  sleep 1
  echo priority-flow-control auto
  sleep 1
  echo priority-flow-control no-drop dot1p 3
  sleep 1
  echo qos apply policy fcoe outbound
  sleep 1
  echo qos trust dot1p
  sleep 1
  echo lldp tlv-enable dot1-tlv dcbx
  sleep 1
  echo quit
  TenGB_Port=$(( TenGB_Port + 1 ))
done
) | telnet $SWITCHIP
