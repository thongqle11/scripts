clear

DIR="/opt/QLogic_Corporation/FW_Dumps/"

echo "WARNING!!!! This script will delete the contents of $DIR. Please backup the contents of this folder before proceeding."
echo

echo "Please enter the first qlcnic interface (i.e. eth4):"
read NET1
echo "Please enter the second qlcnic interface (i.e. eth5):"
read NET2

echo "Please enter the first iSCSI HBA instance from /sys/class/iscsi_host/ (i.e. host3):"
read ISCSI1
echo "Please enter the second iSCSI HBA instance from /sys/class/iscsi_host/ (i.e. host4):"
read ISCSI2

echo "Please enter the first FC/FCoE HBA instance from /sys/class/fc_host/ (i.e. host3):"
read FC1
echo "Please enter the second FC/FCoE HBA instance from /sys/class/fc_host/ (i.e. host4):"
read FC2

echo "Please enter the the number of seconds between iterations:"
read TIMEOUT

clear

while true
do
	rm -rf $DIR/*

	echo "$(date +"%D %T")  Performing FW Dump on /sys/class/net/$NET1"
	logger "Performing FW Dump on /sys/class/net/$NET1"
        echo 0xdeadfeed > /sys/class/net/$NET1/device/fw_dump
	sleep $TIMEOUT

	if [ "$(ls -A $DIR)" ]
	then
		echo "FW_Dump Successful"
	else
		echo "FW_Dump Failed. Directory $DIR Empty."
		exit
	fi
	
	rm -rf $DIR/*

	echo "$(date +"%D %T")  Performing FW Dump on /sys/class/net/$NET2"
	logger "Performing FW Dump on /sys/class/net/$NET2"
        echo 0xdeadfeed > /sys/class/net/$NET2/device/fw_dump
	sleep $TIMEOUT

        if [ "$(ls -A $DIR)" ]
        then
                echo "FW_Dump Successful"
        else
                echo "FW_Dump Failed. Directory $DIR Empty."
                exit
        fi

        rm -rf $DIR/*

	echo "$(date +"%D %T")  Performing FW Dump on /sys/class/iscsi_host/$ISCSI1"
	logger "Performing FW Dump on /sys/class/iscsi_host/$ISCSI1"
        echo 6024 > /sys/class/scsi_host/$ISCSI1/peg_hlt
	sleep $TIMEOUT

	if [ "$(ls -A $DIR)" ]
	then
		echo "FW_Dump Successful"
	else
		echo "FW_Dump Failed. Directory $DIR Empty."
		exit
	fi

	echo "$(date +"%D %T")  Performing FW Dump on /sys/class/iscsi_host/$ISCSI2"
	logger "Performing FW Dump on /sys/class/iscsi_host/$ISCSI2"
        echo 6024 > /sys/class/scsi_host/$ISCSI2/peg_hlt
	sleep $TIMEOUT

	if [ "$(ls -A $DIR)" ]
	then
		echo "FW_Dump Successful"
	else
		echo "FW_Dump Failed. Directory $DIR Empty."
		exit
	fi

	echo "$(date +"%D %T")  Performing FW Dump on /sys/class/fc_host/$FC1"
	logger "Performing FW Dump on /sys/class/fc_host/$FC1"
        echo 3 > /sys/class/fc_host/$FC1/device/fw_dump
	sleep $TIMEOUT

	if [ "$(ls -A $DIR)" ]
	then
		echo "FW_Dump Successful"
	else
		echo "FW_Dump Failed. Directory $DIR Empty."
		exit
	fi

	echo "$(date +"%D %T")  Performing FW Dump on /sys/class/fc_host/$FC2"
	logger "Performing FW Dump on /sys/class/fc_host/$FC2"
        echo 3 > /sys/class/fc_host/$FC2/device/fw_dump
	sleep $TIMEOUT

	if [ "$(ls -A $DIR)" ]
	then
		echo "FW_Dump Successful"
	else
		echo "FW_Dump Failed. Directory $DIR Empty."
		exit
	fi


done
