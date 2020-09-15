#!/bin/bash
date >> reboot.log
lsscsi | grep -c disk >> reboot.log
sleep 300
reboot
