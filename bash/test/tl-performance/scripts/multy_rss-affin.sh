#!/bin/bash
#RSS affinity setup script
#By Vladislav Zolotarov, Broadcom, Oct 2007
#Upgraded to multy interface by Nir Goren. QLogic, Jul 2014
#input: the device name (ethX)
#OFFSET=0   0/1   0/1/2   0/1/2/3
#FACTOR=1    2      3       4
OFFSET=0
FACTOR=1
LASTCPU=`cat /proc/cpuinfo | grep processor | tail -n1 | cut -d":" -f2`
MAXCPUID=`echo 2 $LASTCPU ^  p | dc`
OFFSET=`echo 2 $OFFSET ^  p | dc`
FACTOR=`echo 2 $FACTOR ^  p | dc`
CPUID=1


for eth in $*; do

NUM=`grep $eth /proc/interrupts | wc -l`
NUM_FP=$((${NUM}))

INT=`grep -m 1 $eth /proc/interrupts | cut -d ":" -f 1`

echo  "$eth: ${NUM} (${NUM_FP} fast path) starting irq ${INT}"


CPUID=$((CPUID*OFFSET))
for ((A=1; A<=${NUM_FP}; A=${A}+1)) ; do
	INT=`grep -m $A $eth /proc/interrupts | tail -1  | cut -d ":" -f 1`
	SMP=`echo $CPUID 16 o p | dc`
	echo ${INT} smp affinity set to ${SMP}
	echo  $((${SMP})) > /proc/irq/$((${INT}))/smp_affinity
	CPUID=$((CPUID*FACTOR))
	if [ ${CPUID} -gt ${MAXCPUID} ]; then
		CPUID=1
		CPUID=$((CPUID*OFFSET))
	fi
done
done
