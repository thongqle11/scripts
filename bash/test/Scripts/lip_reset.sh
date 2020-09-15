clear
echo "Enter first host from /sys/class/fc_host/ (i.e. host7):"
read HOST1
echo "Enter second host from /sys/class/fc_host/ (i.e. host8):"
read HOST2

echo "Please enter the the number of seconds between iterations:"
read TIMEOUT

clear

while true
do
        echo "$(date +"%D %T")  Issuing LIP reset to $HOST1"
        logger "**** Issuing LIP reset to $HOST1 ****"
        echo 1 > /sys/class/fc_host/$HOST1/issue_lip
        sleep $TIMEOUT
        
	echo "$(date +"%D %T")  Issuing LIP reset to $HOST2"
        logger "**** Issuing LIP reset to $HOST2 ****"
        echo 1 > /sys/class/fc_host/$HOST2/issue_lip
        sleep $TIMEOUT
done
