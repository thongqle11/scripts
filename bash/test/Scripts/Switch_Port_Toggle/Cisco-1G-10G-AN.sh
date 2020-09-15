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

echo " Please enter seconds between changing speeds"
read time

while true
do
  ( sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo config t
  sleep 2
  
  echo interface ethernet $PORT1 
  sleep 2
  echo speed 1000
  sleep $time
  echo speed 10000
  sleep $time
  echo speed auto
  sleep $time
  
  echo interface ethernet $PORT2
  sleep 2
  echo speed 1000
  sleep $time
  echo speed 10000
  sleep $time
  echo speed auto
  sleep $time


  echo exit
  sleep 2
  echo exit
  sleep 2
  echo exit
  sleep 2
) | telnet $SWITCHIP 
done
