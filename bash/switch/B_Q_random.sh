#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING BROCADE/QLOGIC FC PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"

#Define limits for intervals in minutes
LOWER=5
UPPER=15
RAND_NUM=$[ $[ ( $RANDOM % ( $[ $UPPER - $LOWER ] + 1 ) ) + $LOWER ] * 60 ]

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
  sleep 5
  echo portdisable $PORT11
  echo "Sleeping for $RAND_NUM seconds before enable..." 
  RAND_NUM=$[ $[ ( $RANDOM % ( $[ $UPPER - $LOWER ] + 1 ) ) + $LOWER ] * 60 ] 
  sleep $RAND_NUM
  
  echo portenable $PORT11 
  echo "Sleeping for $RAND_NUM seconds before disable..." 
  RAND_NUM=$[ $[ ( $RANDOM % ( $[ $UPPER - $LOWER ] + 1 ) ) + $LOWER ] * 60 ]
  sleep $RAND_NUM
 
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
  echo "Sleeping for $RAND_NUM seconds before enable..." 
  RAND_NUM=$[ $[ ( $RANDOM % ( $[ $UPPER - $LOWER ] + 1 ) ) + $LOWER ] * 60 ] 
  sleep $RAND_NUM
  
  echo set port $PORT31 state online
  echo "Sleeping for $RAND_NUM seconds before disable..." 
  RAND_NUM=$[ $[ ( $RANDOM % ( $[ $UPPER - $LOWER ] + 1 ) ) + $LOWER ] * 60 ]  
  sleep $RAND_NUM

  echo exit
  sleep 2
) | telnet $SWITCHIP3

done
