#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING Cisco 10G PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"

echo " Please enter the Cisco SWITCH IP"
read SWITCHIP1

echo "Please enter the First 10G Port"
read PORT11

echo "Please enter the Second 10G Port"
read PORT21

echo "Please enter the Third 10G Port"
read PORT31

echo "Please enter the Fourth 10G Port"
read PORT41

echo " Please enter seconds down"
read time_down
echo " Please enter seconds up"
read time_up


while true
do
#Cisco  
  (
  sleep 3
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo config t
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

  echo interface ethernet $PORT31
  echo shut
  sleep $time_down
  echo no shut
  sleep $time_up

  echo interface ethernet $PORT41
  echo shut
  sleep $time_down
  echo no shut
  sleep $time_up

  echo exit
  sleep 2
  ) | telnet $SWITCHIP1

done
