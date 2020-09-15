#!/bin/bash

MTU=(8500 1500 1000 900 800 700 600 500 400 300)

date=`date | sed 's/ \|:/_/g'`


OutDir="Scan_$1_$date"
OutFile="ScanRes_$1.csv"

function Usage {

echo "Usage: ./Test.sh <Test Type> <Run Time> <Logging>";
echo "  Test Type: RX/DUAL_RX/TX/TX_DUAL/BIDIR/DUAL_BIDIR";
echo "  Run Time: test run time in sec";
echo "  Logging: 0/1 - enables logging RX side of port 0 when traffic is active";


};

mkdir $OutDir
echo "MTU,P0 Rx,P1 Rx,P0 Tx,P1 Tx,P0 BRB Dis,P1 BRB Dis,P0 no_buff, P1 no_buff,CPU Idle" > $OutDir/$OutFile


for i in "${MTU[@]}" 
do

	TestDir=$1_$i
#	echo "Runing: ./Test.sh $1 $i $2 $3"
	./Test.sh $1 $i $2 $3
	echo -n "$i," >> $OutDir/$OutFile
	if [ -e $TestDir/RxRunRes0.txt ]; then echo -n "$(cat $TestDir/RxRunRes0.txt)," >> $OutDir/$OutFile; else echo -n "0," >> $OutDir/$OutFile; fi
	if [ -e $TestDir/RxRunRes1.txt ]; then echo -n "$(cat $TestDir/RxRunRes1.txt)," >> $OutDir/$OutFile; else echo -n "0," >> $OutDir/$OutFile; fi
	if [ -e $TestDir/TxRunRes0.txt ]; then echo -n "$(cat $TestDir/TxRunRes0.txt)," >> $OutDir/$OutFile; else echo -n "0," >> $OutDir/$OutFile; fi
	if [ -e $TestDir/TxRunRes1.txt ]; then echo -n "$(cat $TestDir/TxRunRes1.txt)," >> $OutDir/$OutFile; else echo -n "0," >> $OutDir/$OutFile; fi
	if [ -e $TestDir/ethtool0.diff.txt ]; then echo -n "$(grep brb $TestDir/ethtool0.diff.txt | cut -d " " -f 3)," >> $OutDir/$OutFile; else echo -n "0," >> $OutDir/$OutFile; fi
	if [ -e $TestDir/ethtool1.diff.txt ]; then echo -n "$(grep brb $TestDir/ethtool1.diff.txt | cut -d " " -f 3)," >> $OutDir/$OutFile; else echo -n "0," >> $OutDir/$OutFile; fi
	if [ -e $TestDir/ethtool0.diff.txt ]; then echo -n "$(grep buff $TestDir/ethtool0.diff.txt | cut -d " " -f 3)," >> $OutDir/$OutFile; else echo -n "0," >> $OutDir/$OutFile; fi
	if [ -e $TestDir/ethtool1.diff.txt ]; then echo -n "$(grep buff $TestDir/ethtool1.diff.txt | cut -d " " -f 3)," >> $OutDir/$OutFile; else echo -n "0," >> $OutDir/$OutFile; fi
	if [ -e $TestDir/ethtool1.diff.txt ]; then echo -n "$(grep  "Average:     all"  $TestDir/CPUUtil.txt  | cut -c 84-88)," >> $OutDir/$OutFile; else echo -n "0," >> $OutDir/$OutFile; fi
	echo "" >> $OutDir/$OutFile;
	mv $TestDir $OutDir/$TestDir
done

