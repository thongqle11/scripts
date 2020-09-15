#!/bin/bash
SYSTEM='LnxHp-EVA6400-12703'
HOST='"\Hosts\QRF84\TL-14136'
VDISK_LOC='"Virtual Disks\Linux-2\Vdisk0'
MAXLUN=46
NUM=31
VNUM=45
#FILE="C:\Documents and Settings\Administrator\Desktop\eva.sssu"
#echo $SYSTEM $HOST

echo "SELECT SYSTEM "LnxHp-EVA6400-12703""
#echo "FILE \"$FILE\"" 
while [ $NUM -le $MAXLUN ];do
	echo "DELETE LUN $HOST\\$NUM\""
	NUM=$(( $NUM + 1))
done
