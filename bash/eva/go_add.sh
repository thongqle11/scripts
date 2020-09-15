#!/bin/bash
#SYSTEM='LnxHp-EVA6400-12703'
SYSTEM='13767-A22-EVA-P6500'
#SYSTEM='13767-A22-EVA-P6500'
HOST='\Hosts\QRF83\RP_13064_C2'
VDISK_LOC='\Virtual Disks'
LUN_NUMBER_START=2
VNUM_START=1 
VNUM_END=30

echo "SELECT SYSTEM $SYSTEM"
for i in `seq -f '%03g' $VNUM_START $VNUM_END`; do
       echo "ADD LUN $LUN_NUMBER_START HOST=\"$HOST\" VDISK=\"$VDISK_LOC\L1-Vdisk$i\""
	LUN_NUMBER_START=$(( LUN_NUMBER_START + 1 ))
done
