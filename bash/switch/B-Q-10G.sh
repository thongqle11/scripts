#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING BROCADE / Cisco 10G PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"

echo " Please enter the QLogic SWITCH IP of Switch 1"
read SWITCHIP1
echo "Please enter the First 10G Port"
read PORT11

echo " Please enter the Brocade SWITCH IP of Switch 2"
read SWITCHIP2
echo "Please enter the First 10G Port"
read PORT21

echo " Please enter seconds down"
read time_down
echo " Please enter seconds up"
read time_up


while true
do
#QLogic  
  (
  sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo system-view
  sleep 2
  echo interface Ten-GigabitEthernet $PORT11
  echo shutdown 
  sleep $time_down
  
  echo undo shutdown 
  sleep $time_up
 
  echo exit
  sleep 2
  ) | telnet $SWITCHIP1
#Brocade  
  (
  sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  echo cmsh
  sleep 2
  echo config t
  sleep 2
  echo interface tengigabitethernet $PORT21
  sleep 2  
  echo shut 
  sleep $time_down

  echo no shut
  sleep $time_up 

  echo exit
  sleep 2
) | telnet $SWITCHIP2

done
