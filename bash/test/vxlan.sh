ip link add vxlanb1 type vxlan id 42 group 239.1.1.1 dev p6p1 dstport 4789
ip link set vxlanb1 up
ip addr add 10.0.0.2/24 dev vxlanb1

#delete
#ip link delete vxlanb1

#view
#ip -d link show vxlanb1
