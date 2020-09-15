#!/bin/bash

HOSTS="172.24.57.113 172.24.58.144 172.24.58.52 172.24.59.35 172.24.54.9 172.24.57.111 172.24.58.146 172.24.58.54 172.24.59.27 172.24.14.57"
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
