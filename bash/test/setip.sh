ifconfig p6p1 192.168.1.138 up
#ethtool -s p6p1 speed 10000
ifconfig p6p2 192.168.2.138 up
#ethtool -s p6p2 speed 10000
#ifconfig p6p1 inet6 add 2012::138/64 up
#ifconfig p6p2 inet6 add 2012::238/64 up
vconfig add p6p1 11
ifconfig p6p1.11 192.168.3.138 up
#ifconfig p6p1.11 inet6 add 2012::338/64 up
vconfig add p6p2 11
ifconfig p6p2.11 192.168.4.138 up
#ifconfig p6p2.11 inet6 add 2012::438/64 up

