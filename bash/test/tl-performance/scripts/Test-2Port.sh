#!/bin/bash

MyDir=$(pwd)
RemoteIP=172.27.18.146
RemoteEth0=ens2
RemoteTestIP=192.168.1.146
LocalEth0=ens3
LocalTestIP=192.168.1.100
RemoteEth1=eth6
LocalEth1=eth6


function Usage {

echo "Usage: ./Test.sh <Test Type> <MTU> <Run Time> <Logging>";
echo "	Test Type: RX/DUAL_RX/TX/TX_DUAL/BIDIR/DUAL_BIDIR";
echo "	MTU: 64-9000 Test packet size";
echo "	Run Time: test run time in sec"; 
echo "	Logging: 0/1 - enables logging RX side of port 0 when traffic is active";


};

case $1 in
	"RX") 
	Rx=1;
	Dual=0;
	BiDir=0;;
	"DUAL_RX")
	Rx=1;
	Dual=1;
        BiDir=0;;
        "TX")
	Rx=0;
        Dual=0;
        BiDir=0;;
        "DUAL_TX")
	Rx=0;
        Dual=1;
        BiDir=0;;
	"BIDIR")
	Rx=1;
	Dual=0;
        BiDir=1;;
	"DUAL_BIDIR")
	Rx=1;
	Dual=1;
        BiDir=1;;
	*)
	echo "Wrong test type: $1"
	Usage;
	exit 1;;
esac

TestDir=$1_;
ActiveLoging=$4

LediagDir=/usr/local/src/e4/lediag/qlediag_8.0.0.7

echo "Runing $1 Test with MTU of $2"

#Set MTU
ifconfig $LocalEth0 mtu $2 
ssh $RemoteIP "ifconfig $RemoteEth0 mtu $2"
ifconfig $LocalEth1 mtu $2
ssh $RemoteIP "ifconfig $RemoteEth1 mtu $2"
sleep 2

# test Conectivity 
PingCount=$(ping -c 1 192.168.1.146 | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
if [ $PingCount -eq 0 ]; then
  # 100% failed 
echo "Conetivity test port 0 faild before test!!"
exit 1
fi

# test Conectivity
PingCount=$(ping -c 1 192.168.1.146 | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
if [ $PingCount -eq 0 ]; then
  # 100% failed
echo "Conetivity test port 1 faild before test!!"
exit 1
fi


# make results dir 
rm -rf $TestDir2
mkdir -p $TestDir$2
cd $TestDir$2


#capture statistic refrence 
ethtool -S $LocalEth0 > ethtool0.before.txt
if [ $Dual -eq 1 ]; then 
ethtool -S $LocalEth1 > ethtool1.before.txt;
fi
cat /proc/cmdline  > kernel.cmdline.txt

#start test 
if [ $BiDir == 1  -o  $Rx == 0 ] ; then 
/root/e4/performance/netperf-2.6.0/src/super_netperf.sh  64 -H 192.168.1.146 -t TCP_SENDFILE -l $3 >  TxRunRes0.txt &
if [ $Dual -eq 1 ]; then 
/root/e4/performance/netperf-2.6.0/src/super_netperf.sh  64 -H 192.168.2.166 -t TCP_SENDFILE -l $3 >  TxRunRes1.txt &
fi;
fi
if [ $Rx == 1 ]; then 
ssh $RemoteIP "/root/e4/performance/netperf-2.6.0/src/super_netperf.sh  64 -H 192.168.1.100 -t TCP_SENDFILE -l $3" >  RxRunRes0.txt & 
if [ $Dual -eq 1 ]; then 
ssh $RemoteIP "/root/e4/performance/netperf-2.6.0/src/super_netperf.sh  64 -H 192.168.2.164 -t TCP_SENDFILE -l $3" >  RxRunRes1.txt & 
fi
fi 

echo Wating for test to start.. 
#mount -t debugfs nodev /sys/kernel/debug; 
sleep 10

mpstat -P ALL 2 1 > CPUUtil.txt

if [ $ActiveLoging -eq 1 ]; then
echo Logging.. 
#GRC dump
#echo dump > /sys/kernel/debug/qed/04\:00.00/grc  
#cat /sys/kernel/debug/qed/04\:00.00/grc > grcdump.bin

#run lediag 
cd $LediagDir
./load.sh -eng -rc $MyDir/TestRx.tcl
cd $MyDir/$TestDir$2
mv $LediagDir/Profile . 
mv $LediagDir/Profile.csv . 
#v $LediagDir/DebugBus.dmp . 
fi 

echo Wating for test to end.. 
#sleep 30
wait
# get stats 
ethtool -S $LocalEth0 > ethtool0.after.txt
sh ../diffEthtool.sh ethtool0.before.txt ethtool0.after.txt > ethtool0.diff.txt
if [ $Dual -eq 1 ]; then 
ethtool -S $LocalEth1 > ethtool1.after.txt;
sh ../diffEthtool.sh ethtool1.before.txt ethtool1.after.txt > ethtool1.diff.txt;
fi

#report 
if [ -e RxRunRes0.txt ]; then echo -n "Rx port 0: "; cat RxRunRes0.txt; fi 
if [ -e TxRunRes0.txt ]; then echo -n "Tx port 0: "; cat TxRunRes0.txt; fi
if [ -e RxRunRes1.txt ]; then echo -n "Rx port 1: "; cat RxRunRes1.txt; fi 
if [ -e TxRunRes1.txt ]; then echo -n "Tx port 1: "; cat TxRunRes1.txt; fi
