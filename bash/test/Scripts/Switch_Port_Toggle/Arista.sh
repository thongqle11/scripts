#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING Arista FC PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"
echo " Please enter the Arista SWITCH IP "
read SWITCHIP
echo " Please enter the First Port , EX: 1/1 "
read PORT1
echo " Please enter the Second Port , EX: 1/2 "
read PORT2

echo " Please enter seconds down"
read time_down
echo " Please enter seconds up"
read time_up

while true
do
  ( sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo en
  sleep 2
  echo config t
  sleep 2
  echo interface ethernet $PORT1 
  sleep 2
  echo shut
  sleep $time_down
  echo no shutdown
  sleep $time_up
  echo interface ethernet $PORT2 
  sleep 2
  echo shut
  sleep $time_down
  echo no shutdown
  sleep $time_up
  echo exit
  sleep 2
  echo exit
  sleep 2
  echo exit
  sleep 2
) | telnet $SWITCHIP 
done
