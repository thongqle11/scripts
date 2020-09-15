#!/bin/bash
INTERFACE1=p6p1_1
INTERFACE2=p6p2_1
LOG=/root/reboot_check_link.log

/root/setip.sh
sleep 60
#Check 1st Interface
        if  ethtool $INTERFACE1 | grep -i "Link detected" | grep -Fq "yes"
        then
                echo "$(date): $INTERFACE1 is up" >>$LOG

        else
                echo "$(date): $INTERFACE1 is down... Exiting"
                echo "$(date): $INTERFACE1 is down... Exiting" >>$LOG
                exit
        fi


#Check 2nd Interface
        if  ethtool $INTERFACE2 | grep -i "Link detected" | grep -Fq "yes"
        then
                echo "$(date): $INTERFACE2 is up" >>$LOG

        else
                echo "$(date): $INTERFACE2 is down... Exiting"
                echo "$(date): $INTERFACE2 is down... Exiting" >>$LOG
                exit
        fi


sleep 300
reboot
