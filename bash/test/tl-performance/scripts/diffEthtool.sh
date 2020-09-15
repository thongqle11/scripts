#!/bin/bash
# diffs the ethtool statistic outputs between two cuptures 

function getValue {  
        a=$(grep "${1}" "${2}" | cut -d : -f 2); 
        b=$(grep "${1}" "${3}" | cut -d : -f 2);
        res=$((b-a));
	echo "${1}" : $res;};

echo Packets:
getValue tx_ucast_pkts $1 $2
getValue rx_ucast_pkts $1 $2

echo
echo Discards:
getValue no_buff_discards $1 $2
getValue brb_discards $1 $2
getValue mftag_filter_discards $1 $2
getValue mac_filter_discards $1 $2
getValue tx_err_drop_pkts $1 $2


