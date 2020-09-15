#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING Brocade FC PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"
echo " Please enter the Brocade SWITCH IP "
read SWITCHIP
echo " Please enter the First FC Port  "
read PORT1
echo " Please enter the Second FC Port  "
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
  echo portdisable $PORT1
  sleep $time_down
  echo portenable $PORT1 
  sleep $time_up
  echo portdisable $PORT2
  sleep $time_down
  echo portenable $PORT2
  sleep $time_up
  sleep 2
) | telnet $SWITCHIP 
done
