#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING Cisco FC PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"
echo " Please enter the Cisco SWITCH IP "
read SWITCHIP
echo " Please enter the C1P1 FC Port , EX: 1/1 "
read C1P1
echo " Please enter the C1P2 FC Port , EX: 1/2 "
read C1P2
echo " Please enter the C2P1 FC Port , EX: 1/3 "
read C2P1
echo " Please enter the C2P2 FC Port , EX: 1/4 "
read C2P2
while true
do
  ( sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo config t
  sleep 2
  echo interface fc $C1P1 
  sleep 2
  echo shut
  echo interface fc $C1P2 
  sleep 2
  echo shut
  sleep 300
 
  echo interface fc $C1P1
  sleep 2
  echo no shutdown
  echo interface fc $C1P2 
  sleep 2
  echo no shutdown

  sleep 90
  echo interface fc $C2P1 
  sleep 2
  echo shut
  echo interface fc $C2P2 
  sleep 2
  echo shut
  sleep 300
  
  echo interface fc $C2P1
  sleep 2
  echo no shutdown
  echo interface fc $C2P2 
  sleep 2
  echo no shutdown
  
  sleep 90
  echo exit
  sleep 2
  echo exit
  sleep 2
  echo exit
  sleep 2
) | telnet $SWITCHIP 
done
