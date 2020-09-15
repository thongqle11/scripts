#!/bin/sh

#Back up messages file
#NOW=$( date +"%m%d%y-%T" )
#cp /var/log/messages /var/log/messages_$NOW

#Delete contents of messages file
#cat /dev/null > /var/log/messages
#echo "Cleared messages file."

#Remove temp Hazard files
rm -rf /var/tmp/haz*
rm -rf /tmp/ioscan*
echo "Removed Hazard temp files."
