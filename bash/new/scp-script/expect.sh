#!/bin/bash

HOSTS="172.24.57.113 172.24.58.144"

PASSWORD="Qlogic01"
#read -p "Password: " PASSWORD
file=$1
destination_path=$2


for HOST in $HOSTS
do
    expect -c "
    spawn /usr/bin/scp $3 $file root@$HOST:$destination_path
    #spawn /usr/bin/scp file root@$HOST:/destination_path/
    expect {
    "*password:*" { send $PASSWORD\r;interact }
    }
    exit
    "
done
