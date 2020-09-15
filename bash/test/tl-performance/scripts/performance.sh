RemoteIP=172.27.19.80
systemctl stop irqbalance.service
systemctl stop NetworkManager
netserver
./multy_rss-affin.sh ens1-fp
ssh $RemoteIP "/root/e4/performance/scripts/performance.sh"
sysctl -w net.ipv4.tcp_timestamps=0 
sysctl -w net.ipv4.tcp_sack=0 
sysctl -w net.core.netdev_max_backlog=250000 
sysctl -w net.core.rmem_max=16777216 
sysctl -w net.core.wmem_max=16777216 
sysctl -w net.core.rmem_default=16777216 
sysctl -w net.core.wmem_default=16777216 
sysctl -w net.core.optmem_max=16777216 
sysctl -w net.ipv4.tcp_mem="16777216 16777216 16777216" 
sysctl -w net.ipv4.tcp_rmem="4096 87380 16777216" 
sysctl -w net.ipv4.tcp_wmem="4096 65536 16777216" 
