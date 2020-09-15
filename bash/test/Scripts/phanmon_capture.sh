#!/bin/bash

while read cmd args
do
	echo puts '"========="'
	echo puts '"phanmon > ' $cmd ' ' $args '"'
	echo "$cmd $args"
done<<! | ./phanmon >> ./firmware_log.txt
phanstat
srestat
macStatsRx 0
macStatsRx 1
macStatsTx 0
macStatsTx 1
findq
show_ets 0
show_ets 1
show_tc 0
show_tc 1
pcon 0
pcon 1
pcon 2
pcon 3
pcon 4
pr 0
pr 1
pr 2
pr 3
pr 4
epgregs
epgtestmux
show_epg_msg
sreregs
sretestmux
!


