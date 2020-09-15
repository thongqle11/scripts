#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING BROCADE FC PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"

echo " Please enter the BROCADE SWITCH IP of Switch 1"
read SWITCHIP1
echo "Please enter the First FC Port"
read PORT11

echo " Please enter the QLogic SWITCH IP of Switch 2"
read SWITCHIP3
echo "Please enter the First FC Port"
read PORT31

while true
do
  (
  sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo portdisable $PORT11
  sleep 2
  sleep 60
  
  echo portenable $PORT11 
  sleep 2
  sleep 60
 
  echo exit
  sleep 2
) | telnet $SWITCHIP1
  
#QLogic
(
  sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2 
  echo admin start
  sleep 2

  echo set port $PORT31 state down
  sleep 60
  echo set port $PORT31 state online
  sleep 2

  echo exit
  sleep 2
) | telnet $SWITCHIP3

done
