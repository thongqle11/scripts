clear

echo "Please enter the device name attached to the first HBA/CNA port(i.e. /dev/sda):"
read DEVICEID1

echo "Please enter the device name attached to the second HBA/CNA port(i.e. /dev/sdl):"
read DEVICEID2

echo "Please enter the the number of seconds between iterations:"
read TIMEOUT

clear

while true
do
	echo "$(date +"%D %T")  Issuing device reset to device $DEVICEID1"
	logger "**** Issuing device reset to device $DEVICEID1 ****"
	sg_reset -d $DEVICEID1 > /dev/null
	sleep $TIMEOUT
	echo "$(date +"%D %T")  Issuing bus reset to device $DEVICEID1"
	logger "**** Issuing bus reset to device $DEVICEID1 ****"
	sg_reset -b $DEVICEID1 > /dev/null
	sleep $TIMEOUT
	echo "$(date +"%D %T")  Issuing host reset to device $DEVICEID1"
	logger "**** Issuing host reset to device $DEVICEID1 ****"
	sg_reset -h $DEVICEID1 > /dev/null
	sleep $TIMEOUT
	echo "$(date +"%D %T")  Issuing device reset to device $DEVICEID2"
	logger "**** Issuing device reset to device $DEVICEID2 ****"
	sg_reset -d $DEVICEID2 > /dev/null
	sleep $TIMEOUT
	echo "$(date +"%D %T")  Issuing bus reset to device $DEVICEID2"
	logger "**** Issuing bus reset to device $DEVICEID2 ****"
	sg_reset -b $DEVICEID2 > /dev/null
	sleep $TIMEOUT
	echo "$(date +"%D %T")  Issuing host reset to device $DEVICEID2"
	logger "**** Issuing host reset to device $DEVICEID2 ****"
	sg_reset -h $DEVICEID2 > /dev/null
	sleep $TIMEOUT
done
