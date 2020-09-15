#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING H3C / Condor PORTS*"
echo "***************************************"
echo "***************************************"

echo " Please enter the H3C SWITCH IP "
read SWITCHIP1
telnet $SWITCHIP1 < /dev/tty

  sleep 2
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo system-view

Module_Switch=1
while [ $Module_Switch -le 2 ];do
(
  sleep 2
  echo admin
  sleep 2
  echo Qlogic01
  sleep 2
  echo system-view
  sleep 2
  echo Module_Switch is $Module_Switch
  ) | telnet $SWITCHIP1
Module_Switch=$(( Module_Switch + 1 ))
done


