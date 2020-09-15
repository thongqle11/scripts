#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING BROCADE / Cisco 10G PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"

#echo " Please enter the Cisco SWITCH IP of Switch 1"
#read SWITCHIP1
#echo "Please enter the  Port"
#read PORT11
SWITCHIP1=172.27.16.60
PORT11=1/17

#echo " Please enter the HP 5900 SWITCH IP of Switch 2"
#read SWITCHIP2
#echo "Please enter the First 10G Port"
#read PORT21
SWITCHIP2=172.27.17.62
PORT21=1/0/49


#echo " Please enter seconds down"
#read time_down
#echo " Please enter seconds up"
#read time_up
time_down=30
time_up=120


while true
do
#Cisco  
  (
  sleep 5
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
 
  echo exit
  sleep 2
  ) | telnet $SWITCHIP1
#HP 5900  
  (
  sleep 5
  echo system-view
  sleep 2
  echo interface FortyGigE $PORT21
  sleep 2  
  echo shut 
  sleep $time_down

  echo undo shut
  sleep $time_up 

  echo quit
  echo quit
  echo quit
  sleep 2
) | telnet $SWITCHIP2

done
