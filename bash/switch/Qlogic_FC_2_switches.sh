#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING QLOGIC FC PORTS ON/OFF   *"
echo "******ON TWO DIFFERENT SWITCHES********"
echo "***************************************"

echo " Please enter the QLogic SWITCH IP of Switch 1"
read SWITCHIP1
echo "Please enter the 1st FC Port on first switch"
read PORT11
echo "Please enter the 2nd FC Port on second switch"
read PORT12
echo " Please enter the QLogic SWITCH IP of Switch 2"
read SWITCHIP2
echo "Please enter the 1st FC Port on second switch" 
read PORT21
echo "Please enter the 2nd FC Port on second switch" 
read PORT22
echo "Please enter the time down" 
read timedown
echo "Please enter the time up" 
read timeup

username=USERID
password=PASSW0RD
while true
do
#Switch 1 
(
  sleep 2
  echo $username
  sleep 5
  echo $password
  sleep 2 
  echo admin start
  sleep 2

  echo set port $PORT11 state down
  echo set port $PORT12 state down
  sleep $timedown

  echo set port $PORT11 state online
  echo set port $PORT12 state online
  sleep $timeup
  echo exit
) | telnet $SWITCHIP1

#Switch 2
(
  sleep 2
  echo $username
  sleep 5
  echo $password
  sleep 2
  echo admin start
  sleep 2

  echo set port $PORT21 state down
  echo set port $PORT22 state down
  sleep $timedown

  echo set port $PORT21 state online
  echo set port $PORT22 state online
  sleep $timeup
  echo exit
) | telnet $SWITCHIP2

done
