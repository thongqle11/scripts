echo Please enter the First DM for the FCoE instance
read DEVICEID1

echo Please enter the Second  DM for the FCoE instance
read DEVICEID2

echo Please enter the First DM for the iSCSI instance
read DEVICEID3

echo Please enter the Second DM for the iSCSI instance
read DEVICEID4

while true
do
####################################BUS Reset###########
logger -s ADC FORCED BUS RESET
sg_reset -b /dev/$DEVICEID1
sleep 35
logger -s ADC FORCED BUS RESET
sg_reset -b /dev/$DEVICEID2
sleep 35
logger -s ADC FORCED BUS RESET
sg_reset -b /dev/$DEVICEID3
sleep 35
logger -s ADC FORCED BUS RESET
sg_reset -b /dev/$DEVICEID4
sleep 35
####################################Device Reset###########
logger -s ADC FORCED DEVICE RESET
sg_reset -d /dev/$DEVICEID1
sleep 35
logger -s ADC FORCED DEVICE RESET
sg_reset -d /dev/$DEVICEID2
sleep 35
logger -s ADC FORCED DEVICE  RESET
sg_reset -d /dev/$DEVICEID3
sleep 35
logger -s ADC FORCED DEVICE  RESET
sg_reset -d /dev/$DEVICEID4
####################################Target  Reset###########
logger -s ADC FORCED TARGET RESET
sg_reset -t /dev/$DEVICEID1
sleep 60
logger -s FORCED TARGET RESET 
sg_reset -t /dev/$DEVICEID2
sleep 60
logger -s ADC FORCED TARGET  RESET
sg_reset -t /dev/$DEVICEID3
sleep 60
logger -s ADC FORCED TARGET  RESET
sg_reset -t /dev/$DEVICEID4
done
####################################Host Adapter Reset###########
logger -s ADC FORCED HOST RESET
sg_reset -h /dev/$DEVICEID1
sleep 60
logger -s FORCED HOST RESET 
sg_reset -h /dev/$DEVICEID2
sleep 60
logger -s ADC FORCED HOST  RESET
sg_reset -h /dev/$DEVICEID3
sleep 60
logger -s ADC FORCED HOST  RESET
sg_reset -h /dev/$DEVICEID4
done
