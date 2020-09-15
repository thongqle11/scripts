#!/bin/bash
INT=eth4
IP=fe80::20e:1eff:fe50:8280
DEST=fe80::20e:1eff:fec4:81b6
sock -f$IP%$INT-$DEST -Y1 -M0 $*
