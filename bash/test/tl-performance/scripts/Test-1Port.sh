#!/bin/bash

MyDir=$(pwd)
RemoteIP=172.27.19.80
RemoteEth0=ens1
RemoteTestIP=192.168.1.80
LocalEth0=ens1
LocalTestIP=192.168.1.78

function Usage {

echo "Usage: ./Test.sh <Test Type> <MTU> <Run Time> <Logging>";
echo "	Test Type: RX/TX/BIDIR";
echo "	MTU: 64-9000 Test packet size";
echo "	Run Time: test run time in sec"; 

};

case $1 in
	"RX") 
	Rx=1;
	Dual=0;
	BiDir=0;;
	
	"TX")
	Rx=0;
        Dual=0;
        BiDir=0;;
        
	"BIDIR")
	Rx=1;
	Dual=0;
        BiDir=1;;
	
	*)
	echo "Wrong test type: $1"
	Usage;
	exit 1;;
esac

TestDir=$1_;

echo "******************************"
echo "$1 Test with MTU of $2"

#Set IPs
ifconfig $LocalEth0 $LocalTestIP
ssh $RemoteIP "ifconfig $RemoteEth0 $RemoteTestIP"
sleep 2

#Set MTU
ifconfig $LocalEth0 mtu $2 
ssh $RemoteIP "ifconfig $RemoteEth0 mtu $2"
sleep 2

# test Connectivity 
PingCount=$(ping -c 1 $RemoteTestIP | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
if [ $PingCount -eq 0 ]; then
  # 100% failed 
echo "Connectivity test port 0 failed before test!!"
exit 1
fi

# make results dir 
rm -rf $TestDir$2
sleep 5
mkdir -p $TestDir$2
cd $TestDir$2

#capture statistic reference 
ethtool -S $LocalEth0 > ethtool0.before.txt
cat /proc/cmdline  > kernel.cmdline.txt

#start test 
if [ $BiDir == 1  -o  $Rx == 0 ] ; then 
/root/e4/performance/netperf-2.6.0/src/super_netperf.sh 64 -H $RemoteTestIP -t TCP_SENDFILE -l $3 >  TxRunRes0.txt &
fi

if [ $Rx == 1 ]; then 
ssh $RemoteIP "/root/e4/performance/netperf-2.6.0/src/super_netperf.sh 64 -H $LocalTestIP -t TCP_SENDFILE -l $3" >  RxRunRes0.txt & 
fi 

sleep 1

mpstat -P ALL 2 1 > CPUUtil.txt

wait
# get stats 
ethtool -S $LocalEth0 > ethtool0.after.txt
sh ../diffEthtool.sh ethtool0.before.txt ethtool0.after.txt > ethtool0.diff.txt

#report 
if [ -e RxRunRes0.txt ]; then echo -n "Rx port 0: "; cat RxRunRes0.txt; fi 
if [ -e TxRunRes0.txt ]; then echo -n "Tx port 0: "; cat TxRunRes0.txt; fi
if [ -e RxRunRes1.txt ]; then echo -n "Rx port 1: "; cat RxRunRes1.txt; fi 
if [ -e TxRunRes1.txt ]; then echo -n "Tx port 1: "; cat TxRunRes1.txt; fi
