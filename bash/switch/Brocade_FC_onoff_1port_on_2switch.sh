#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING BROCADE CEE PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"

disable_duration=60
duration_between_ports=120
password=password

echo " Please enter the BROCADE SWITCH IP of Switch 1"
read SWITCHIP1
echo "Please enter the First FC Port"
read PORT11

echo " Please enter the BROCADE SWITCH IP of Switch 2"
read SWITCHIP2
echo "Please enter the First FC Port"
read PORT21


while true
do
  (
  sleep 5
  echo admin
  sleep 2
  echo $password
  sleep 2
  echo portdisable $PORT11
  sleep 2
  sleep $disable_duration
  
  echo portenable $PORT11 
  sleep 2
  sleep $duration_between_ports
 
  echo exit
  sleep 2
) | telnet $SWITCHIP1
  
  (
  sleep 5
  echo admin
  sleep 2
  echo $password
  sleep 2
  echo portdisable $PORT21
  sleep 2
  sleep $disable_duration

  echo portenable $PORT21
  sleep 2
  sleep $duration_between_ports

  echo exit
  sleep 2
) | telnet $SWITCHIP2
done
