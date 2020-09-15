#!/bin/bash

HOSTS="172.24.12.218 172.24.12.215" 
#HOSTS="172.24.12.215 172.24.12.218 172.24.16.24 172.24.16.21 172.24.12.213 172.24.12.214" 
PASSWORD="Qlogic01"
file=$1
destination_path=/drivers/


if [ "$#" == "0" ]; then
    echo "Usage:"
    echo "./expect-recursive.sh [driver]"
    exit
fi

for HOST in $HOSTS
do
    expect -c "
    spawn /usr/bin/scp -o stricthostkeychecking=no  $file root@$HOST:$destination_path
    expect {
    "*password:*" { send $PASSWORD\r;interact }
    }
    exit
    "
done

#Start DD creation process
for HOST in $HOSTS
do
	echo "Creating dd-kit for $HOST"	
	rsh $HOST /root/tl.sh $file &
done
