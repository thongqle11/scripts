#!/bin/bash
IP=192.168.80.194
DEST=192.168.89.139
sock -f$IP:$DEST -Y1 -M0 $*
