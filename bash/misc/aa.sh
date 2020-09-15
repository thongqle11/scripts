#!/bin/bash


#regex="[0-9]{1,3}"
regex='[0-9]\{1,3\}:[0-9]\{1,3\}'
echo $regex
#for i in `cat input |  awk '/path/{$0=$regex}1'`;do
#cat input | awk '/path/{$0=\$regex}1'

cat input | grep -o $regex
#cat input | awk '/$regex/{ print $6}'
 #       device=$(cat mpath.tmp | grep -w $i | awk '{print $3}')
 #       lsscsi_output=$(cat lsscsi.tmp | grep -w $device)
 #       echo $i ">" $device ">" $lsscsi_output
#echo $i

