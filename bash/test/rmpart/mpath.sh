#!/bin/bash
NOW=$( date +"%m%d%y-%H%M%S" )
multipath -ll > /root/rmpart/mpath-$NOW
ls -al /dev/mapper >> /root/rmpart/mpath-$NOW
