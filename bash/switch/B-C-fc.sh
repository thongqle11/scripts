#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING BROCADE / Cisco FC PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"

echo " Please enter the BROCADE SWITCH IP of Switch 1"
read SWITCHIP1
echo "Please enter the First FC Port"
read PORT11

echo " Please enter the Cisco SWITCH IP of Switch 2"
read SWITCHIP2
echo "Please enter the First FC Port"
read PORT21

echo " Please enter seconds down"
read time_down
echo " Please enter seconds up"
read time_up

while true
do
  (
  sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo portdisable $PORT11
  sleep $time_down
  
  echo portenable $PORT11 
  sleep $time_up
 
  echo exit
  sleep 2
  ) | telnet $SWITCHIP1
#Cisco  
  (
  sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  echo config t
  sleep 2
  
  echo interface fc $PORT21
  sleep 2  
  echo shut 
  sleep $time_down

  echo no shut
  sleep $time_up 

  echo exit
  sleep 2
) | telnet $SWITCHIP2

done
