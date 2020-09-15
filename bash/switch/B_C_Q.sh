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

echo " Please enter the QLogic SWITCH IP of Switch 2"
read SWITCHIP3
echo "Please enter the First FC Port"
read PORT31
echo "Please enter the Second FC Port" 
read PORT32

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
#Disable Cisco  
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
  sleep 2

  echo exit
  sleep 2
) | telnet $SWITCHIP2
  
#Disable QLogic
(
  sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2 
  echo admin start
  sleep 2

  echo set port $PORT31 state down
  sleep 2
  echo set port $PORT32 state down
  sleep 300

  echo exit
  sleep 2
) | telnet $SWITCHIP3
#Enable Cisco
(
  sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo config t
  sleep 2

  echo interface fc $PORT21
  sleep 2
  echo no shut
  sleep 2
  echo interface fc $PORT22
  sleep 2
  echo no shut
  sleep 2
  
  echo exit
  sleep 2
) | telnet $SWITCHIP2

#Enable QLogic
(
  sleep 5
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo admin start
  sleep 2

  echo set port $PORT31 state online
  sleep 2
  echo set port $PORT32 state online
  sleep 2
  sleep 300

  echo exit
  sleep 2
) | telnet $SWITCHIP3


done
