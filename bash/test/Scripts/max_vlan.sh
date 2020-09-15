#!/bin/bash
#$echo "Specify NIC inteface"
#read interface
interface=p4p1
#echo "Specify starting vlan"
#read vlan_start
#echo "Specifiy ending vlan"
#read vlan_end
vlan_start=2
vlan_end=4096
j=1
k=1
l=1
m=1
n=1
o=1
p=1
q=1
r=1
s=1
t=1
u=1
v=1
w=1
x=1
y=1
z=1
if [ "$1" == "delete" ]
then
	for a in $(seq $vlan_start $vlan_end);do
	  vconfig rem $interface.$a
	done
end
fi
for i in $(seq $vlan_start $vlan_end); do 
	echo $i 
	vconfig add $interface $i
	if [ $i -le 255 ]
	then
		  ifconfig $interface.$i 192.168.$j.3 netmask 255.255.255.0 up
		  j=$((j+1))
	elif [ $i -ge 256 ] && [ $i -le 510 ]
	then
		  ifconfig $interface.$i 192.168.$k.4 netmask 255.255.255.0 up
		  k=$((k+1))
	elif [ $i -ge 511 ] && [ $i -le 755 ]
	then
		  ifconfig $interface.$i 192.168.$l.5 netmask 255.255.255.0 up
		  l=$((l+1))
	elif [ $i -ge 756 ] && [ $i -le 1010 ]
	then
		  ifconfig $interface.$i 192.168.$m.6 netmask 255.255.255.0 up
		  m=$((m+1))
	elif [ $i -ge 1011 ] && [ $i -le 1266 ]
	then
		  ifconfig $interface.$i 192.168.$n.7 netmask 255.255.255.0 up
		  n=$((n+1))
	elif [ $i -ge 1267 ] && [ $i -le 1522 ]
	then
		  ifconfig $interface.$i 192.168.$o.7 netmask 255.255.255.0 up
                  o=$((o+1))
	elif [ $i -ge 1523 ] && [ $i -le 1778 ]
	then
		  ifconfig $interface.$i 192.168.$p.8 netmask 255.255.255.0 up
		  p=$((p+1))
	elif [ $i -ge 1779 ] && [ $i -le 2035 ]
	then
		  ifconfig $interface.$i 192.168.$q.9 netmask 255.255.255.0 up
		  q=$((q+1))
	elif [ $i -ge 2036 ] && [ $i -le 2291 ]
	then
		  ifconfig $interface.$i 192.168.$r.10 netmask 255.255.255.0 up
		  r=$((r+1))
	elif [ $i -ge 2292 ] && [ $i -le 2548 ]
	then
		  ifconfig $interface.$i 192.168.$s.10 netmask 255.255.255.0 up
		  s=$((s+1))
	elif [ $i -ge 2549 ] && [ $i -le 2804 ]
	then
		  ifconfig $interface.$i 192.168.$t.10 netmask 255.255.255.0 up
		  t=$((t+1))
	elif [ $i -ge 2805 ] && [ $i -le 3060 ]
	then
		  ifconfig $interface.$i 192.168.$u.11 netmask 255.255.255.0 up
		  u=$((u+1))
	elif [ $i -ge 3061 ] && [ $i -le 3316 ]
	then
		  ifconfig $interface.$i 192.168.$v.12 netmask 255.255.255.0 up
		  v=$((v+1))
	elif [ $i -ge 3317 ] && [ $i -le 3572 ]
	then
		  ifconfig $interface.$i 192.168.$w.13 netmask 255.255.255.0 up
		  w=$((w+1))
	elif [ $i -ge 3573 ] && [ $i -le 3828 ]
	then
		  ifconfig $interface.$i 192.168.$x.14 netmask 255.255.255.0 up
		  x=$((x+1))
	elif [ $i -ge 3829 ] && [ $i -le 4084 ]
	then
		  ifconfig $interface.$i 192.168.$y.15 netmask 255.255.255.0 up
		  y=$((y+1))
	elif [ $i -ge 4089 ] && [ $i -le 4096 ]
	then
		  ifconfig $interface.$i 192.168.$z.16 netmask 255.255.255.0 up
		  z=$((z+1))
	else
		echo "out of range"
	fi
done
