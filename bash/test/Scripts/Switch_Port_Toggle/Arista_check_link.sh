#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING Arista PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"

SWITCHIP1=172.27.19.135
PORT1=30/1
PORT2=30/2
INTERFACE1=eno49
INTERFACE2=eno50
time_down=3
time_up=10
LOG=/root/Arista.log

while true
do

#####PORT 1###########
  (
  sleep 3
  echo admin
  sleep 2
  echo Qlogic01
  sleep 4
  echo enable
  sleep 2
  echo configure
  sleep 2

  echo interface ethernet $PORT1
  echo shut
  sleep $time_down
  echo no shut
  echo exit
  sleep $time_up
  ) | telnet $SWITCHIP1

        if  ethtool $INTERFACE1 | grep -i "Link detected" | grep -Fq "yes"
        then
                echo "$(date): $INTERFACE1 is up" >>$LOG

        else
                echo "$(date): $INTERFACE1 is down... Exiting"
                echo "$(date): $INTERFACE1 is down... Exiting" >>$LOG
                exit
        fi




#####PORT 2###########
  (
  sleep 3
  echo admin
  sleep 2
  echo Qlogic01
  sleep 4
  echo enable
  sleep 2
  echo configure
  sleep 2

  echo interface ethernet $PORT2
  echo shut
  sleep $time_down
  echo no shut
  echo exit
  sleep $time_up
  ) | telnet $SWITCHIP1

        if  ethtool $INTERFACE2 | grep -i "Link detected" | grep -Fq "yes"
        then
                echo "$(date): $INTERFACE2 is up" >>$LOG

        else
                echo "$(date): $INTERFACE2 is down... Exiting"
                echo "$(date): $INTERFACE2 is down... Exiting" >>$LOG
                exit
        fi

done
