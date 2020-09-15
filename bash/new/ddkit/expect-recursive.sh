#!/bin/bash

HOSTS="172.24.12.215 172.24.12.218 172.24.16.24 172.24.16.21 172.24.12.213 172.24.12.214" 
PASSWORD="Qlogic01"

file=$1
destination_path=$2


if [ "$#" == "0" ]; then
    echo "Usage:"
    echo "./expect-recursive.sh [file/folder(s)_to_send] [destination_path] [-r]"
    echo "Use -r if folder"
    exit
fi

for HOST in $HOSTS
do
    expect -c "
    spawn /usr/bin/scp -o stricthostkeychecking=no $3 $file root@$HOST:$destination_path
    expect {
    "*password:*" { send $PASSWORD\r;interact }
    }
    exit
    "
done
