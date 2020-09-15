#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING Arista PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"

echo " Please enter the Arista SWITCH IP"
read SWITCHIP1
echo "Please enter the First Port"
read PORT11

echo "Please enter the Second Port"
read PORT21

echo " Please enter seconds down"
read time_down
echo " Please enter seconds up"
read time_up


while true
do
#Arista
  (
  sleep 3
  echo admin
  sleep 2
  echo Qlogic01
  sleep 4
  echo enable
  sleep 2
  echo configure
  sleep 2

  echo interface ethernet $PORT11
  echo shut 
  sleep $time_down
  
  echo no shut 
  sleep $time_up

  echo interface ethernet $PORT21
  echo shut 
  sleep $time_down
  
  echo no shut 
  sleep $time_up
  
  echo exit
  sleep 2
  ) | telnet $SWITCHIP1

done
