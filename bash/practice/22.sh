#!/bin/bash
DATE=$(date)
USERS=$(who)
UPTIME=$(uptime)
echo $DATE
echo $DATE >> 22.log
echo $USERS
echo $USERS >> 22.log
echo $UPTMIE
echo $UPTIME >> 22.log
