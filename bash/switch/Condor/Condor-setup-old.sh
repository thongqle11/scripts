#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING H3C / Condor PORTS*"
echo "***************************************"
echo "***************************************"

echo " Please enter the H3C SWITCH IP "
read SWITCHIP1

#while true;do
(
  sleep 2
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo system-view
  sleep 2
  

 echo interface Ten-GigabitEthernet1/1/1
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

 echo interface Ten-GigabitEthernet1/1/2
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

 echo interface Ten-GigabitEthernet1/1/3
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

 echo interface Ten-GigabitEthernet1/1/4
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

 echo interface Ten-GigabitEthernet1/2/1
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

 echo interface Ten-GigabitEthernet1/2/2
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

 echo interface Ten-GigabitEthernet1/2/3
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

 echo interface Ten-GigabitEthernet1/2/4
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
  
  echo interface Ten-GigabitEthernet1/0/1
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
  
  echo interface Ten-GigabitEthernet1/0/2
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

  echo interface Ten-GigabitEthernet1/0/3
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

  echo interface Ten-GigabitEthernet1/0/4
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

  echo interface Ten-GigabitEthernet1/0/5
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

  echo interface Ten-GigabitEthernet1/0/6
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

  echo interface Ten-GigabitEthernet1/0/7
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

  echo interface Ten-GigabitEthernet1/0/8
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

  echo interface Ten-GigabitEthernet1/0/9
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

  echo interface Ten-GigabitEthernet1/0/10
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

  echo interface Ten-GigabitEthernet1/0/11
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

  echo interface Ten-GigabitEthernet1/0/12
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

  echo interface Ten-GigabitEthernet1/0/13
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

  echo interface Ten-GigabitEthernet1/0/14
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

) | telnet $SWITCHIP1
#done

