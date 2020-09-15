modprobe bonding mode=1 miimon=100 updelay=50000 primary=eth6
ifconfig bond0 192.168.11.113 netmask 255.255.240.0 up
ifenslave bond0 eth6 eth7

