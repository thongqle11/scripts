#!/bin/bash
date >> /root/reboot.log
lsscsi | grep -c disk >> /root/reboot.log
sleep 300
reboot
