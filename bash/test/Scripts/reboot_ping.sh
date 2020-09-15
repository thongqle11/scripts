#!/bin/bash

INTERFACE1=eno49
INTERFACE2=eno50
SLEEP_TIME=300
LOG=/root/reboot_check_link.log


if ethtool $INTERFACE1 | grep -i "Link detected" | grep -Fq "yes"
        then
                echo "$(date): $INTERFACE1 is up" >>$LOG

        else
                echo "$(date): $INTERFACE1 is down... Exiting"
                echo "$(date): $INTERFACE1 is down... Exiting" >>$LOG
                exit
        fi

if ethtool $INTERFACE2 | grep -i "Link detected" | grep -Fq "yes"
        then
                echo "$(date): $INTERFACE2 is up" >>$LOG

        else
                echo "$(date): $INTERFACE2 is down... Exiting"
                echo "$(date): $INTERFACE2 is down... Exiting" >>$LOG
                exit
        fi

sleep $SLEEP_TIME
reboot
