#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING Cisco FC PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"
echo " Please enter the Cisco SWITCH IP "
read SWITCHIP
echo " Please enter the First FC Port , EX: 1/1 "
read PORT1
echo " Please enter the Second FC Port , EX: 1/2 "
read PORT2
while true
do
  ( sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo config t
  sleep 2
  echo interface fc $PORT1 
  sleep 2
  echo shut
  sleep 300
  echo no shutdown
  sleep 90
  echo interface fc $PORT2 
  sleep 2
  echo shut
  sleep 300
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
