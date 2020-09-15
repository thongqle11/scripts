clear

DIR="/opt/QLogic_Corporation/FW_Dumps/"

echo "WARNING!!!! This script will delete the contents of $DIR. Please backup the contents of this folder before proceeding."
echo

echo "Please enter the first HBA instance from /sys/class/fc_host/ (i.e. host3):"
read DEVICEID1

echo "Please enter the second HBA instance from /sys/class/fc_host/ (i.e. host4):"
read DEVICEID2

echo "Please enter the the number of seconds between iterations:"
read TIMEOUT

clear

while true
do
	rm -rf $DIR/*

	echo "$(date +"%D %T")  Performing FW Dump on /sys/class/fc_host/$DEVICEID1"
	logger "Performing FW Dump on /sys/class/fc_host/$DEVICEID1"
        echo 3 > /sys/class/fc_host/$DEVICEID1/device/fw_dump
	sleep $TIMEOUT

	if [ "$(ls -A $DIR)" ]
	then
		echo "FW_Dump Successful"
	else
		echo "FW_Dump Failed. Directory $DIR Empty."
		exit
	fi
	
	rm -rf $DIR/*

	echo "$(date +"%D %T")  Performing FW Dump on /sys/class/fc_host/$DEVICEID2"
	logger "Performing FW Dump on /sys/class/fc_host/$DEVICEID2"
        echo 3 > /sys/class/fc_host/$DEVICEID2/device/fw_dump
	sleep $TIMEOUT

	if [ "$(ls -A $DIR)" ]
	then
		echo "FW_Dump Successful"
	else
		echo "FW_Dump Failed. Directory $DIR Empty."
		exit
	fi

done
