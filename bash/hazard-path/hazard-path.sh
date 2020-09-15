#!/bin/bash

echo "Where is multipath output?"
echo '	1. Use "multipath -ll" output.  This may take a while if system is overloaded.'
echo "	2. Input from file."
read answer
case $answer in
        "1")	echo 'Getting "multipath -ll" output...' 
		multipath -ll > mpath.tmp
		echo 'Done.';; 
	"2") echo "Enter location of file. ex. /root/mpath.txt"
		read file
		#check if file exists	
		if [ -e "$file" ]; then
			cat $file > mpath.tmp
		else
			echo "File does not exist.  Exiting..."
			exit
		fi;;
esac
#Check mpath.tmp is valid
grep -q "dm-" mpath.tmp && a=found || a=missing 
if [ "$a" = missing ]; then
	echo "Not a valid multipath file.  Exiting..."	
	exit
fi	

lsscsi > lsscsi.tmp
regex='[0-9]\{1,3\}:[0-9]\{1,3\}'
for i in `cat input |  sed -n 's/^.*\([p][a][t][h] [^ ]*\).*/\1/p' | cut -d " " -f2| cut -d. -f1`;do
#for i in `cat input | grep -o $regex`;do
	device=$(cat mpath.tmp | grep -w $i | awk '{print $3}')
	lsscsi_output=$(cat lsscsi.tmp | grep -w $device)
	echo $i ">" $device ">" $lsscsi_output
done

rm -f mpath.tmp
rm -f lsscsi.tmp
