#!/bin/bash
SET1=192.168.1.140:192.168.1.124
SET2=192.168.2.140:192.168.2.124
sock -f$SET1,$SET2 -Y1 -M0 $*
