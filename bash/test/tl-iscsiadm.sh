iscsiadm -m iface -I bnx2i.00:10:18:c3:9b:b1 -o update -n iface.ipaddress -v 192.168.4.240
iscsiadm -m iface -I bnx2i.00:10:18:c3:9b:b1 -o update -n iface.subnet_mask -v 255.255.240.0
iscsiadm -m iface -I bnx2i.00:10:18:c3:9b:b1 -o update -n iface.initiatorname -v iqn.SUT6207-Quark1

iscsiadm -m iface -I bnx2i.00:10:18:c3:9b:b3 -o update -n iface.ipaddress -v 192.168.4.241
iscsiadm -m iface -I bnx2i.00:10:18:c3:9b:b3 -o update -n iface.subnet_mask -v 255.255.240.0
iscsiadm -m iface -I bnx2i.00:10:18:c3:9b:b3 -o update -n iface.initiatorname -v iqn.SUT6207-Quark2

#ipv6
#iscsiadm -m iface -I bnx2i.00:10:18:c3:9b:b1 -o update -n iface.ipaddress -v abcd:54
#iscsiadm -m iface -I bnx2i.00:10:18:c3:9b:b3 -o update -n iface.ipaddress -v abcd:55
#Edit /etc/network-scripts/ifcfg-eth0
#DHCPV6C=yes
#IPV6ADDR=abcd::52

#iscsiadm -m discovery -t st -p 192.168.4.20 -I bnx2i.00:10:18:c3:9b:b1
#iscsiadm -m discovery -t st -p 192.168.4.20 -I bnx2i.00:10:18:c3:9b:b3


#RHEL5.x
# BEGIN RECORD 2.0-872.16.el5
#iface.iscsi_ifacename = bnx2i.00:10:18:c3:9b:b3
#iface.net_ifacename = <empty>
#iface.ipaddress = abcd::55
#iface.hwaddress = 00:10:18:c3:9b:b3
#iface.transport_name = bnx2i
#iface.initiatorname = iqn.SUT6207-Quark2
#iface.bootproto = <empty>
#iface.subnet_mask = <empty>
#iface.gateway = <empty>
#iface.ipv6_autocfg = <empty>
#iface.linklocal_autocfg = <empty>
#iface.router_autocfg = <empty>
#iface.ipv6_linklocal = <empty>
#iface.ipv6_router = <empty>
#iface.state = <empty>
#iface.vlan_id = 0
#iface.vlan_priority = 0
#iface.vlan_state = <empty>
#iface.iface_num = 0
#iface.mtu = 0
#iface.port = 0
# END RECORD

