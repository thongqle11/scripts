server=GAD17991_client
int1=ens2f0
int2=ens2f1
dir=/root/bug
dmesg -T > $dir/${server}_dmesg
ethtool -d $int1 > $dir/${server}_ethtool_dump_$int1
ethtool -d $int2 > $dir/${server}_ethtool_dump_$int2
