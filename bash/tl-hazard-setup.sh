#!/bin/sh

haz_server=hazard-ml570
haz_ip=172.24.50.118
clear
#Check /etc/hosts file
if grep -Fxq "$haz_ip $haz_server" /etc/hosts
then
	echo "/etc/hosts already has entry"
else
	echo "Modifying /etc/hosts file..."
	echo $haz_ip $haz_server >> /etc/hosts
fi

#Check /etc/hosts.allow file
if grep -Fxq "ALL:ALL" /etc/hosts.allow
then
        echo "/etc/hosts.allow already has entry"
else
	echo "Modifying /etc/hosts.allow file..."
	echo ALL:ALL >> /etc/hosts.allow
fi

#Check if /root/.rhosts file exists, and create it if it doesn't.
test -e /root/.rhosts || touch /root/.rhosts

#Check /root/.rhosts file for ALL:ALL
if grep -Fxq "$haz_server root" /root/.rhosts
then
        echo "/root/.rhosts already has entry"
else
        echo "Modifying /root/.rhosts file..."
        echo $haz_server root >> /root/.rhosts
fi

#Check if rlogin is in /etc/securetty file
if grep -Fxq "rlogin" /etc/securetty
then
        echo "rlogin already in /etc/securetty file"
else
        echo "Adding rlogin to /etc/securetty file..."
        echo rlogin  >> /etc/securetty
fi

#Check if rexec is in /etc/securetty file
if grep -Fxq "rexec" /etc/securetty
then
        echo "rexec already in /etc/securetty file"
else
        echo "Adding rexec to /etc/securetty file..."
        echo rexec  >> /etc/securetty
fi

#Check if rsh is in /etc/securetty file
if grep -Fxq "rsh" /etc/securetty
then
        echo "rsh already in /etc/securetty file"
else
        echo "Adding rsh to /etc/securetty file..."
        echo rsh  >> /etc/securetty
fi

chkconfig rlogin on
echo chkconfig rlogin on
chkconfig rexec on
echo chkconfig rexec on
chkconfig rsh on
echo chkconfig rsh on

service xinetd restart

echo "If hazard server still cannot rsh, try the following and restart xinetd (service xinetd restart)"
echo "	1. link path of ksh. ln -s /bin/ksh /usr/bin/ksh (RHEL6 only)"
echo "	2. set SELINUX to permissive or disabled (RHEL6). (vi /etc/selinux/config)"
echo "	3. enable rsh. vi /etc/xinetd.d/rsh (RHEL6) (disable=no)"

