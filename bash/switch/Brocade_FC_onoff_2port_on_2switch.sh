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
echo "Please enter the Second FC Port" 
read PORT12
echo "Please enter the Third FC Port" 
read PORT13
echo "Please enter the Fourth FC Port" 
read PORT14
echo "Please enter the Fifth FC Port" 
read PORT15
echo "Please enter the Sixth FC Port" 
read PORT16


echo " Please enter the Cisco SWITCH IP of Switch 2"
read SWITCHIP2
echo "Please enter the First FC Port"
read PORT21
echo "Please enter the Second FC Port" 
read PORT22


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
  echo portdisable $PORT12
  sleep 2
  echo portdisable $PORT13
  sleep 2
  echo portdisable $PORT14
  sleep 2
  echo portdisable $PORT15
  sleep 2
  echo portdisable $PORT16
  sleep 300
  
  echo portenable $PORT11 
  sleep 2
  echo portenable $PORT12 
  sleep 2
  echo portenable $PORT13 
  sleep 2
  echo portenable $PORT14 
  sleep 2
  echo portenable $PORT15 
  sleep 2
  echo portenable $PORT16 
  sleep 300
 
  echo exit
  sleep 2
) | telnet $SWITCHIP1
  
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
  sleep 2
  echo interface fc $PORT22
  sleep 2 
  echo shut 
  sleep 300

  echo interface fc $PORT21
  sleep 2
  echo no shut
  sleep 2
  echo interface fc $PORT22
  sleep 2
  echo no shut
  sleep 300

  echo exit
  sleep 2
) | telnet $SWITCHIP2
done
