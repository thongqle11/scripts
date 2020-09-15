#!/bin/sh
echo "***************************************"
echo "***************************************"
echo "   SETTING Cisco PORTS ON/OFF   *"
echo "***************************************"
echo "***************************************"

SWITCHIP1=172.27.18.178
PORT1=1/6
PORT2=1/8
INTERFACE1=eth6
INTERFACE2=eth7
time=5
LOG=/root/Cisco.log

while true
do



#####PORT 1###########
for switch_speed in 1000 10000 auto
{
  
#Port 1
  (
  sleep 3
  echo admin
  sleep 2
  echo Qlogic01
  sleep 4
  echo configure terminal
  sleep 2

  echo interface ethernet $PORT1
  sleep 2
  echo speed $switch_speed
  sleep 5
  echo exit
  ) | telnet $SWITCHIP1
	if ethtool $INTERFACE1 | grep -i "speed" | grep -Fq "1000Mb"
	then
		echo "$(date): $INTERFACE1 is running at 1G" >>$LOG
			if [ "$switch_speed" = "1000" ]
                        then
                                :
                        else
                                echo "$(date): $INTERFACE1 speed does not match $switch_speed... Exiting"
                                echo "$(date): $INTERFACE1 speed does not match $switch_speed... Exiting" >>$LOG
                                exit
			fi


	else ethtool $INTERFACE2 | grep -i "speed" | grep -Fq "10000Mb"
			if [ "$switch_speed" = "10000" ] || [ "$switch_speed" = "auto" ]
				echo "$(date): $INTERFACE2 is running at 10G or auto" >>$LOG
			then 
				:
			else
				echo "$(date): $INTERFACE2 speed does not match $switch_speed... Exiting"
		                echo "$(date): $INTERFACE2 speed does not match $switch_speed... Exiting" >>$LOG
				exit
			fi
	fi
	sleep $time

#Port 2
  (
  sleep 3
  echo admin
  sleep 2
  echo Qlogic01
  sleep 4
  echo configure terminal
  sleep 2

  echo interface ethernet $PORT2
  sleep 2
  echo speed $switch_speed
  sleep 5
  echo exit
  ) | telnet $SWITCHIP1
        if ethtool $INTERFACE1 | grep -i "speed" | grep -Fq "1000Mb"
        then
                echo "$(date): $INTERFACE1 is running at 1G" >>$LOG
                        if [ "$switch_speed" = "1000" ]
                        then
                                :
                        else
                                echo "$(date): $INTERFACE1 speed does not match $switch_speed... Exiting"
                                echo "$(date): $INTERFACE1 speed does not match $switch_speed... Exiting" >>$LOG
                                exit
                        fi


        else ethtool $INTERFACE2 | grep -i "speed" | grep -Fq "10000Mb"
                        if [ "$switch_speed" = "10000" ] || [ "$switch_speed" = "auto" ]
				echo "$(date): $INTERFACE2 is running at 10G or auto" >>$LOG
                        then
                                :
                        else
                                echo "$(date): $INTERFACE2 speed does not match $switch_speed... Exiting"
                                echo "$(date): $INTERFACE2 speed does not match $switch_speed... Exiting" >>$LOG
                                exit
                        fi
        fi
        sleep $time

}


done

