#!/bin/bash
BASEDIR=$(dirname $0)
# TEST_SCRIPT_DIR=`pwd`/$BASEDIR
CURRENT_DIR=`pwd`
TEST_SCRIPT_DIR=$BASEDIR
# echo $TEST_SCRIPT_DIR
#############################################################
#	Common Functions
#############################################################
function get_driver_version()
{
	driver_name=$1
	if [ -n $driver_name ]; then
		if [ "$driver_name" == "qcc" ]; then
			rpm -qa | grep QConvergeConsoleCLI | sed s/QConvergeConsoleCLI-//g 
		else
			modinfo $driver_name | grep ^version: | awk '{print $2}'
		fi
	fi
}

##############################################################
#	Mount the common EIT share
##############################################################
MV_NETAPP_IP="10.29.12.49"
QIDL_NETAPP_IP="10.35.8.157"  #qidlnaengr02

if [ "35" == "`ifconfig  | grep 'inet addr:172'  | awk '{print $2}' | cut -d\. -f2`" ]; then
	eit_tool_share_ip=$QIDL_NETAPP_IP
	echo "search qlogic.org" > /etc/resolv.conf
        echo "nameserver 172.35.10.201" >> /etc/resolv.conf
        echo "nameserver 10.35.2.11" >> /etc/resolv.conf
        echo "nameserver 10.35.2.19" >> /etc/resolv.conf
else
	eit_tool_share_ip=$MV_NETAPP_IP

fi
ping $eit_tool_share_ip -c 1 >/dev/null
if [ $? != 0 ]; then
        echo "Could Not able to ping common share $eit_tool_share_ip . Install the drivers manually"
else
	mount | grep /usr/qlc/apps/eit_tools > /dev/null
	if [ $? != 0 ]; then
	        mkdir -pm 777 /usr/qlc/apps/eit_tools
	        mount $eit_tool_share_ip:/vol/engr_apps02/eit_tools /usr/qlc/apps/eit_tools
	        if [ $? != 0 ]; then
        	        echo "Could Not able to mount $eit_tool_share_ip:/vol/engr_apps02/eit_tools, Install the drivers manually"
	        fi
	fi
fi


#dut_drop_latest_path="/usr/qlc/apps/eit_tools/drivers/latest/"
##########################################################################
#	Identify the Distro name and kernel version	
##########################################################################
KERNEL_VERSION=`uname -r`
KERNEL_MAJ_MIN=`echo $KERNEL_VERSION | cut -d . -f -2`
KERNEL_FLAV=`echo $KERNEL_VERSION | cut -d - -f 3`
KER_VER_NO_FL=""
ARCH=`uname -p`

if [ -f "/etc/SuSE-release" ]; then
        OS="SLES"
        OS_REL=`cat /etc/SuSE-release | grep VERSION | awk '{print $3}'`
        OS_VERSION=`cat /etc/SuSE-release | grep PATCHLEVEL | awk '{print $3}'`
elif [  -f "/etc/redhat-release"  ]; then
	if cat /etc/redhat-release | grep "Red Hat Enterprise Linux Server" > /dev/null; then
	        OS="RHEL"
        	OS_REL=`cat /etc/redhat-release | cut -d " " -f 7 | cut -d . -f 1`
	        OS_VERSION=`cat /etc/redhat-release | cut -d " " -f 7 | cut -d . -f 2`
	elif cat /etc/redhat-release | grep "XenServer" > /dev/null; then
	        OS="XS"
        	OS_REL=`cat /etc/redhat-release | cut -d " " -f 3 | cut -d . -f 1`
	        OS_VERSION=`cat /etc/redhat-release | cut -d " " -f 3 | cut -d . -f 2`
		KERNEL_FLAV=`uname -r | awk -F "[1-9]" '{print $NF}'`
		KKERNEL_VERSION=`uname -r | sed s/$KERNEL_FLAV//g`
	fi
fi

DUT_drop_base_path="/home/drop"
dut_drop_latest_path="$DUT_drop_base_path/latest"
CMN_SHARE_PATH="/usr/qlc/apps/eit_tools/common/SW_Drop"
mkdir -p $DUT_drop_base_path

##########################################
#	Choose the OEM Package
##########################################
echo "List of SW Release"
echo "  1)  HP 10 90"
echo "  2)  Dell Taurus"
echo "  3)  2013 U1"
echo "  4)  Helga"

if [ -n "$1" ]; then
	OEM=$1
else
	echo -n "Enter your choice [Default: 3]: "
	read -t 60 OEM
	if [ -z $OEM ]; then
		echo
		OEM="3"
	fi	
fi
while true
do
	#################################################################
	#	Copy the package into local driver			#
	#################################################################
	case $OEM in 
	1)	#echo "HP"  #HP 1090
		echo "Selected OEM: 1) HP 1090"
		OEM_NAME="HP 1090"
		HP_DROP_PATH="$CMN_SHARE_PATH/HP_1090"
		#dut_drop_latest_path="/usr/qlc/apps/eit_tools/common/SW_Drop/Dell_Taurus/latest/Linux"
		cd $HP_DROP_PATH
		latest_drop=`ls -l | grep latest | awk '{print $NF}'`

		###	COPY P3 Driver to local filesystem     ####
		NIC_P3_SRC_PATH="$HP_DROP_PATH/latest/P3/Drivers_NIC Linux"
		DUT_SRC_PATH="$DUT_drop_base_path/$latest_drop/driver/src"
		DUT_RPM_PATH="$DUT_drop_base_path/$latest_drop/driver/rpm"
		DUT_UTILS_RPM_PATH="$DUT_drop_base_path/$latest_drop/utils"
		mkdir -p $DUT_SRC_PATH
		mkdir -p $DUT_RPM_PATH
		mkdir -p $DUT_UTILS_RPM_PATH
		cd "$NIC_P3_SRC_PATH"
		cp nx_nic*tgz $DUT_SRC_PATH
		NIC_RPM_PATH="$HP_DROP_PATH/latest/P3/Drivers_NIC Linux RPM/$OS$OS_REL/$OS$OS_REL.$OS_VERSION"
		if [ -d "$NIC_RPM_PATH" ]; then
			cd "$NIC_RPM_PATH"
			if [ -f ../../utils/hp-nx_nic-tools*.rpm ]; then
				cp ../../utils/hp-nx_nic-tools*.rpm $DUT_UTILS_RPM_PATH
			fi
			if [ "$OS" == "RHEL" ]; then
				if [[ ("$KERNEL_FLAV" == "xen" || "$KERNEL_FLAV" == "PAE")  && "$OS_REL" == "5" ]] ; then
					if [ "$ARCH" == "x86_64" ]; then
						cp kmod-hpqlgc-nx_nic-$KERNEL_FLAV-*x86_64.rpm $DUT_RPM_PATH
						cp kmod-hpqlgc-nx_xport-$KERNEL_FLAV-*x86_64.rpm $DUT_RPM_PATH
					else
						cp kmod-hpqlgc-nx_nic-$KERNEL_FLAV-*i?86.rpm $DUT_RPM_PATH
						cp kmod-hpqlgc-nx_xport-$KERNEL_FLAV-*i?86.rpm $DUT_RPM_PATH
					fi
				else
					if [ "$ARCH" == "x86_64" ]; then
						cp kmod-hpqlgc-nx_nic-[1-9]*x86_64.rpm $DUT_RPM_PATH
						cp kmod-hpqlgc-nx_xport-[1-9]*x86_64.rpm $DUT_RPM_PATH
					else
						cp kmod-hpqlgc-nx_nic-[1-9]*i?86.rpm $DUT_RPM_PATH
						cp kmod-hpqlgc-nx_xport-[1-9]*i?86.rpm $DUT_RPM_PATH
					fi
				fi
			elif [ "$OS" == "SLES" ]; then
				if [ "$ARCH" == "x86_64" ]; then
					cp hpqlgc-nx_nic-kmp-$KERNEL_FLAV-*x86_64.rpm $DUT_RPM_PATH
					cp hpqlgc-nx_xport-kmp-$KERNEL_FLAV-*x86_64.rpm $DUT_RPM_PATH
				else
					cp hpqlgc-nx_nic-kmp-$KERNEL_FLAV-*i?86.rpm $DUT_RPM_PATH
					cp hpqlgc-nx_xport-kmp-$KERNEL_FLAV-*i?86.rpm $DUT_RPM_PATH
				fi
			fi
		else
			echo "ERROR: P3 driver rpm is not present in drop for OS $OS$OS_REL.$OS_VERSION"
		fi
		###	COPY P3P NIC Driver and app to local filesystem
		NIC_P3P_SRC_PATH="$HP_DROP_PATH/latest/P3P/Drivers_NIC Linux"
		cd "$NIC_P3P_SRC_PATH"
		# TO DO: Need to copy only the respective driver
		cp qlcnic*/hp-qlcnic-src*tgz $DUT_SRC_PATH/
		NIC_P3P_RPM_PATH="$HP_DROP_PATH/latest/P3P/Drivers_NIC Linux RPM/$OS$OS_REL/$OS$OS_REL.$OS_VERSION"
		if [ -d "$NIC_P3P_RPM_PATH" ]; then
			cd "$NIC_P3P_RPM_PATH"
			cp ../../utils/hp-qlgc-utils-*rpm $DUT_UTILS_RPM_PATH
			if [ "$OS" == "RHEL" ]; then
				if [[ ("$KERNEL_FLAV" == "xen" || "$KERNEL_FLAV" == "PAE")  && "$OS_REL" == "5" ]] ; then
					if [ "$ARCH" == "x86_64" ]; then
						cp kmod-hpqlgc-qlcnic-$KERNEL_FLAV-*x86_64.rpm $DUT_RPM_PATH
					else
						cp kmod-hpqlgc-qlcnic-$KERNEL_FLAV-*i?86.rpm $DUT_RPM_PATH
					fi
				else
					if [ "$ARCH" == "x86_64" ]; then
						cp kmod-hpqlgc-qlcnic-[1-9]*x86_64.rpm $DUT_RPM_PATH
					else
						cp kmod-hpqlgc-qlcnic-[1-9]*i?86.rpm $DUT_RPM_PATH
					fi
				fi
			elif [ "$OS" == "SLES" ]; then
				if [ "$ARCH" == "x86_64" ]; then
					cp hpqlgc-qlcnic-kmp-$KERNEL_FLAV-*x86_64.rpm $DUT_RPM_PATH
				else
					cp hpqlgc-qlcnic-kmp-$KERNEL_FLAV-*i?86.rpm $DUT_RPM_PATH
				fi
			fi
		else
			echo "ERROR: QLCNIC rpm is not present in drop for OS $OS$OS_REL.$OS_VERSION"
		fi
		###	COPY iSCSI Driver and app to local filesystem
		ISCSI_P3P_SRC_PATH="$HP_DROP_PATH/latest/P3P/Drivers_iSCSI Linux"
		cd "$ISCSI_P3P_SRC_PATH"
		if [[ ("$OS$OS_REL" == "RHEL6" || "$OS$OS_REL" == "SLES11" ) && $OS_VERSION -gt 1 ]]; then #RHEL 6.2, 6.3, 6.4, SLES 11 SP2
			cp qla4xxx-src-v*.00.00-k?.tar.gz $DUT_SRC_PATH
		elif [[ "$OS" == "XEN" || "$OS$OS_REL" == "RHEL6" || "$OS$OS_REL" == "SLES11" ]]; then	# Citrix XenServer 5.6 FP1/6.0.2/6.1, SLES 11 SP1,  RHEL 6.0, 6.1
			cp qla4xxx-src-v*-c?.tar.gz $DUT_SRC_PATH
		elif [[ "$OS$OS_REL" == "RHEL5" ]]; then	# Red Hat RHEL 5.6/5.7/5.8/5.9
			cp qla4xxx-src-v*.0[1-9].0[1-9]-k?.tar.gz $DUT_SRC_PATH
		elif [[ "$OS$OS_REL" == "SLES10" ]]; then #SLES 10 SP3/SLES 10 SP4
			cp qla4xxx-src-v*-d?.tar.gz $DUT_SRC_PATH
		else
			echo "ERROR: QLA4xxx src is not present in drop for OS $OS$OS_REL.$OS_VERSION"
		fi
		ISCSI_P3P_RPM_PATH="$HP_DROP_PATH/latest/P3P/Drivers_iSCSI Linux RPM/$OS$OS_REL/$OS$OS_REL.$OS_VERSION"
		if [ -d "$ISCSI_P3P_RPM_PATH" ]; then
			cd "$ISCSI_P3P_RPM_PATH"
			if [ "$OS" == "RHEL" ]; then
				if [[ ("$KERNEL_FLAV" == "xen" || "$KERNEL_FLAV" == "PAE")  && "$OS_REL" == "5" ]] ; then
					if [ "$ARCH" == "x86_64" ]; then
						cp kmod-hpqlgc-qla4xxx-$KERNEL_FLAV-*x86_64.rpm $DUT_RPM_PATH
					else
						cp kmod-hpqlgc-qla4xxx-$KERNEL_FLAV-*i?86.rpm $DUT_RPM_PATH
					fi
				else
					if [ "$ARCH" == "x86_64" ]; then
						cp kmod-hpqlgc-qla4xxx-[1-9]*x86_64.rpm $DUT_RPM_PATH
					else
						cp kmod-hpqlgc-qla4xxx-[1-9]*i?86.rpm $DUT_RPM_PATH
					fi
				fi
			elif [ "$OS" == "SLES" ]; then
				if [ "$ARCH" == "x86_64" ]; then
					cp hpqlgc-qla4xxx-kmp-$KERNEL_FLAV-*x86_64.rpm $DUT_RPM_PATH
				else
					cp hpqlgc-qla4xxx-kmp-$KERNEL_FLAV-*i?86.rpm $DUT_RPM_PATH
				fi
			fi
		else
			echo "ERROR: QLA4xxx rpm is not present in drop for OS $OS$OS_REL.$OS_VERSION"
		fi
		###	COPY FCOE Driver and app to local filesystem
		FCOE_P3P_SRC_PATH="$HP_DROP_PATH/latest/P3P/Drivers_FCoE Linux"
		cd "$FCOE_P3P_SRC_PATH"
		if [ "$OS$OS_REL" == "RHEL5" ]; then #RHEL 5.x
			cp qla2xxx-src-v*.5.?-k.tar.gz $DUT_SRC_PATH
		elif [ "$OS$OS_REL" == "RHEL6" ]; then	# RHEL 6.x
			cp qla2xxx-src-v*.06.?-k.tar.gz $DUT_SRC_PATH
		elif [ "$OS$OS_REL" == "SLES10" ]; then	# SLES10.x
			cp qla2xxx-src-v*.10.?-k.tar.gz $DUT_SRC_PATH
		elif [ "$OS$OS_REL" == "SLES10" ]; then #SLES 11.x
			cp qla2xxx-src-v*.11.?-k.tar.gz $DUT_SRC_PATH
		elif [ "$OS$OS_REL" == "XS6" ]; then #CITRIX XEN Server 6.x
			cp qla2xxx-src-v*.55.?-k.tar.gz $DUT_SRC_PATH
		else
			echo "ERROR: QLA2xxx src is not present in drop for OS $OS$OS_REL.$OS_VERSION"
		fi
		FCOE_P3P_RPM_PATH="$HP_DROP_PATH/latest/P3P/Drivers_FCoE Linux RPM/$OS$OS_REL/$OS$OS_REL.$OS_VERSION"
		if [ "$FCOE_P3P_RPM_PATH" ]; then
			cd "$FCOE_P3P_RPM_PATH"
			if [ "$OS" == "RHEL" ]; then
				if [[ ("$KERNEL_FLAV" == "xen" || "$KERNEL_FLAV" == "PAE")  && "$OS_REL" == "5" ]] ; then
					if [ "$ARCH" == "x86_64" ]; then
						cp kmod-hpqlgc-qla2xxx-$KERNEL_FLAV-*x86_64.rpm $DUT_RPM_PATH
					else
						cp kmod-hpqlgc-qla2xxx-$KERNEL_FLAV-*i?86.rpm $DUT_RPM_PATH
					fi
				else
					if [ "$ARCH" == "x86_64" ]; then
						cp kmod-hpqlgc-qla2xxx-[1-9]*x86_64.rpm $DUT_RPM_PATH
					else
						cp kmod-hpqlgc-qla2xxx-[1-9]*i?86.rpm $DUT_RPM_PATH
					fi
				fi
			elif [ "$OS" == "SLES" ]; then
				if [ "$ARCH" == "x86_64" ]; then
					cp hpqlgc-qla2xxx-kmp-$KERNEL_FLAV-*x86_64.rpm $DUT_RPM_PATH
				else
					cp hpqlgc-qla2xxx-kmp-$KERNEL_FLAV-*i?86.rpm $DUT_RPM_PATH
				fi
			fi
		else
			echo "ERROR: QLA2xxx rpm is not present in drop for OS $OS$OS_REL.$OS_VERSION"
		fi
		###	COPY qaucli appto local filesystem
		QCC_P3P_RPM_PATH="$HP_DROP_PATH/latest/P3P/QConvergeConsole CLI_Linux"
		DUT_RPM_PATH="$DUT_drop_base_path/$latest_drop/qcc_cli"
		mkdir -p $DUT_RPM_PATH
		cd "$QCC_P3P_RPM_PATH"
		if [ "$ARCH" == "x86_64" ]; then
			cp QConvergeConsoleCLI-*x86_64.rpm $DUT_RPM_PATH
		else
			cp QConvergeConsoleCLI-*i?86.rpm $DUT_RPM_PATH
		fi

		###	COPY qaucli remote agent to local filesystem
		QCC_AGENT_P3P_RPM_PATH="$HP_DROP_PATH/latest/P3P/QConvergeConsole QLRemote Agent Installer_Linux"
		DUT_RPM_PATH="$DUT_drop_base_path/$latest_drop/qcc_remote_agent"
		mkdir -p $DUT_RPM_PATH
		cd "$QCC_AGENT_P3P_RPM_PATH"
		if [ "$ARCH" == "x86_64" ]; then
			cp *x86_64.rpm $DUT_RPM_PATH
		else
			cp *i?86.rpm $DUT_RPM_PATH
		fi


		###	COPY FW to local filesystem
		FW_P3P_PATH="$HP_DROP_PATH/latest/P3P/QLAFWUpdate_Linux"
		DUT_RPM_PATH="$DUT_drop_base_path/$latest_drop/fw"
		mkdir -p $DUT_RPM_PATH
		cd "$FW_P3P_PATH"
		if [ "$ARCH" == "x86_64" ]; then
			cp *64.tgz $DUT_RPM_PATH
		else
			cp *i?86.tgz $DUT_RPM_PATH
		fi

		### Create the soft link to latest drop
		cd $DUT_drop_base_path
		rm -f latest
		ln -s $DUT_drop_base_path/$latest_drop latest
	;;


	2)	#echo "DELL"  #DELL TAURUS
		echo "Selected OEM: 2) DELL TAURUS"
		OEM_NAME="DELL TAURUS"
		cd /usr/qlc/apps/eit_tools/common/SW_Drop/Dell_Taurus
		latest_drop=`ls -l | grep latest | awk '{print $NF}'`
		# Create local directory for driver and apps
		DUT_SRC_PATH="$DUT_drop_base_path/$latest_drop/driver/src"
		DUT_RPM_PATH="$DUT_drop_base_path/$latest_drop/driver/rpm"
		DUT_UTILS_RPM_PATH="$DUT_drop_base_path/$latest_drop/utils"
		DUT_QCC_PATH="$DUT_drop_base_path/$latest_drop/qcc_cli"
		DUT_FW_PATH="$DUT_drop_base_path/$latest_drop/fw"
		DUT_AGENT_PATH="$DUT_drop_base_path/$latest_drop/qcc_remote_agent"
		mkdir -p $DUT_SRC_PATH
		mkdir -p $DUT_RPM_PATH
		mkdir -p $DUT_UTILS_RPM_PATH
		mkdir -p $DUT_QCC_PATH
		mkdir -p $DUT_FW_PATH
		mkdir -p $DUT_AGENT_PATH
		OS_NAME="`echo $OS | tr '[:upper:]' '[:lower:]'`$OS_REL.$OS_VERSION"
		#echo $OS_NAME
		driver_share_path="/usr/qlc/apps/eit_tools/common/SW_Drop/Dell_Taurus/latest/Linux/$OS_NAME"
		Apps_share_path="/usr/qlc/apps/eit_tools/common/SW_Drop/Dell_Taurus/latest/Linux/Apps"
		#	Coping the driver and application rpm
		cp /usr/qlc/apps/eit_tools/common/SW_Drop/Dell_Taurus/latest/Linux/utils/* $DUT_UTILS_RPM_PATH/
		if echo $OS_NAME | grep -E "rhel5|sles10" >/dev/null; then
			cp $driver_share_path/rpms/*rpm $DUT_RPM_PATH/
			## 	Install dkms rpm package
			#dkms_installed_rpm=`rpm -qa | grep dkms-`
			rpm -ivh $DUT_RPM_PATH/dkms*rpm >/dev/null 2>&1
		fi
		if [ "$ARCH" == "x86_64" ]; then
			cp $driver_share_path/rpms/*x86_64.rpm $DUT_RPM_PATH/ >/dev/null 2>&1
			cp $Apps_share_path/QCC_CLI/*x86_64.rpm $DUT_QCC_PATH/
			cp $Apps_share_path/QCC_GUI/Agent/*x86_64.rpm $DUT_AGENT_PATH/
			cp $Apps_share_path/fw_update/*x64.tar.gz $DUT_FW_PATH/
		else
			cp $driver_share_path/rpms/*i?86.rpm $DUT_RPM_PATH/ >/dev/null 2>&1
			cp $Apps_share_path/QCC_CLI/*i?86.rpm $DUT_QCC_PATH/
			cp $Apps_share_path/QCC_GUI/Agent/*i?86.rpm $DUT_AGENT_PATH/
			cd $Apps_share_path/fw_update
			cp `ls | grep -v "x64.tar.gz"` $DUT_FW_PATH/
		fi
		#	Coping driver source
		cp $driver_share_path/src/*gz $DUT_SRC_PATH/

		### Create the soft link to latest drop
		cd $DUT_drop_base_path
		rm -f latest
		ln -s $DUT_drop_base_path/$latest_drop latest
	;;

	3|4)    #2013 U1 or Helga
		if [ "$OEM" == "3"  ]; then  # 2013 U1
			echo "Selected OEM: 3) 2013 U1"
			OEM_NAME="2013 U1"
			DROP_PATH="$CMN_SHARE_PATH/2013_U1"
		elif [ "$OEM" == "4" ]; then # Helga
			echo "Selected OEM: 4) Helga"
			OEM_NAME="Helga"
			DROP_PATH="$CMN_SHARE_PATH/Helga"
		fi
		cd $DROP_PATH
		latest_drop=`ls -l | grep latest | awk '{print $NF}'`
		if [ "$OS" == "SLES" ]; then
			OS_NAME_NIC="`echo $OS | tr '[:upper:]' '[:lower:]'`${OS_REL}sp$OS_VERSION"
		else
			OS_NAME_NIC="`echo $OS | tr '[:upper:]' '[:lower:]'`${OS_REL}.$OS_VERSION"
		fi
		OS_NAME="`echo $OS | sed 's/\(.\)\(.*\)/\1\L\2/'`_$OS_REL.$OS_VERSION"
		# Create local directory for driver and apps
		DUT_DRV_SRC_PATH="$DUT_drop_base_path/$latest_drop/driver/src"
		DUT_QCC_RPM_PATH="$DUT_drop_base_path/$latest_drop/qcc_cli"
		DUT_FW_PKG_PATH="$DUT_drop_base_path/$latest_drop/fw"
		DUT_QCC_RMT_AGNT_PATH="$DUT_drop_base_path/$latest_drop/qcc_remote_agent"
		mkdir -p $DUT_DRV_SRC_PATH
		mkdir -p $DUT_QCC_RPM_PATH
		mkdir -p $DUT_FW_PKG_PATH
		mkdir -p $DUT_QCC_RMT_AGNT_PATH

		###	COPY NIC Driver to local filesystem
		NIC_SRC_PATH="$DROP_PATH/latest/Drivers_NIC_Linux/"
		rm -rf /tmp/NIC
		mkdir -p /tmp/NIC
		cd "$NIC_SRC_PATH"
		for i in `ls q*tgz`
		do
			cd "$NIC_SRC_PATH"
			nic_driver=`echo $i | cut -d - -f -1`
			cp $i /tmp/NIC/
			cd /tmp/NIC/
			tar xvf $i > /dev/null 2>&1
			cd $nic_driver*-QLogic
			tar xvf *tgz  > /dev/null 2>&1
			cd $nic_driver*-src
			nic_pkg=`ls | grep $OS_NAME_NIC`
			if [ -f "$nic_pkg" ]; then
				cp $nic_pkg $DUT_DRV_SRC_PATH/
			else
				echo "ERROR: Couldn't find the nic source for OS $OS_NAME_NIC"
			fi
		done
		###	COPY FCoE Driver to local filesystem
		FCOE_SRC_PATH="$DROP_PATH/latest/Drivers_FCoE_Linux/$OS_NAME"
		if [ -d "$FCOE_SRC_PATH" ]; then
			cd "$FCOE_SRC_PATH"
			cp qla2xxx-src*tar.gz $DUT_DRV_SRC_PATH/
		else
			echo "ERROR: FCoE driver package is not present for OS $OS_NAME on Helga Drop."
		fi
		
		###	COPY iSCSI Driver to local filesystem
		iSCSI_SRC_PATH="$DROP_PATH/latest/Drivers_iSCSI_Linux/$OS_NAME"
		if [ -d "$iSCSI_SRC_PATH" ]; then
			cd "$iSCSI_SRC_PATH"
			cp qla4xxx-src*tar.gz $DUT_DRV_SRC_PATH/
		else
			echo "ERROR: iSCSI driver package is not present for OS $OS_NAME on Helga Drop."
		fi
		
		###	COPY qaucli appto local filesystem
		QCC_RPM_PATH="$DROP_PATH/latest/QConvergeConsole_CLI_Linux"
		cd "$QCC_RPM_PATH"
		if [ "$ARCH" == "x86_64" ]; then
			cp QConvergeConsoleCLI-*x86_64.rpm $DUT_QCC_RPM_PATH
		else
			cp QConvergeConsoleCLI-*i?86.rpm $DUT_QCC_RPM_PATH
		fi

		###	COPY qaucli remote agent to local filesystem
		QCC_AGENT_RPM_PATH="$DROP_PATH/latest/QConvergeConsole_QLRemote_Agent_Installer_Linux"
		cd "$QCC_AGENT_RPM_PATH"
		if [ "$ARCH" == "x86_64" ]; then
			cp *x86_64.rpm $DUT_QCC_RMT_AGNT_PATH
		else
			cp *i?86.rpm $DUT_QCC_RMT_AGNT_PATH
		fi


		###	COPY FW to local filesystem
		FW_PKG_PATH="$DROP_PATH/latest/Flash_Packages_Utilities"
		cd "$FW_PKG_PATH"
		cp *zip $DUT_FW_PKG_PATH

		### Create the soft link to latest drop
		cd $DUT_drop_base_path
		rm -f latest
		ln -s $DUT_drop_base_path/$latest_drop latest
	;;

	*) #Not matching with any OEM
	  if [ -n "$1" ]; then
		shift
		if echo $OEM | grep -E -i "hp|1090|10_90" >/dev/null ; then
			OEM=1
		elif echo $OEM | grep -E -i "dell|taurus" >/dev/null ; then
			OEM=2
		elif echo $OEM | grep -E -i "u1|2013" >/dev/null ; then
			OEM=3
		elif echo $OEM | grep -E -i "helga" >/dev/null ; then
			OEM=4
		fi
	  else
		echo -n "Invalid Choice. Enter 1, 2, 3 or 4 [Default 3]: "
		read -t 60 OEM
		if [ -z $OEM ]; then
			echo
			OEM="3"
		fi	
	  fi
           continue
	;;
	esac
	break
done
################################3######################
#	QLCNIC Driver Installation from local copy
#######################################################
echo "========================================"
echo "    INFO: Installing NIC Driver         "
echo "========================================"
qlcnic_old_version=$(get_driver_version qlcnic)
qlge_old_version=$(get_driver_version qlge)
if [ "$OEM" == "1"  ]; then  # HP 1090
	nxnic_old_version=$(get_driver_version nx_nic)
	#OS_NAME="$OS$OS_REL"
	installed_nic_package=`rpm -qa | grep qlcnic`
	installed_p3_package=`rpm -qa | grep hpqlgc-nx_nic`
	installed_xport_package=`rpm -qa | grep nx_xport`
	installed_p3_utils_package=`rpm -qa | grep hp-nx_nic-tools`
	echo "Uninstalling following old NIC RPM packages"
	if [ -n "$installed_nic_package" ]; then
		echo "		$installed_nic_package"
		rpm -e $installed_nic_package >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "		ERROR: uninstallation failed"
		fi
	fi
	if [ -n "$installed_p3_package" ]; then
		echo "		$installed_p3_package"
		rpm -e $installed_p3_package >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "		ERROR: uninstallation failed"
		fi
	fi
	if [ -n "$installed_xport_package" ]; then
		echo "		$installed_xport_package"
		rpm -e $installed_xport_package >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "		ERROR: uninstallation failed"
		fi
	fi
	if [ -n "$installed_p3_utils_package" ]; then
		echo "		$installed_p3_utils_package"
		rpm -e $installed_p3_utils_package >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "		ERROR: uninstallation failed"
		fi
	fi
	driver_rpm_path="$dut_drop_latest_path/driver/rpm"
	utils_rpm_path="$dut_drop_latest_path/utils"
	cd $driver_rpm_path
	p3_name=`ls *hpqlgc-nx_nic*rpm`
	xport_name=`ls *nx_xport*rpm`
	cd $driver_rpm_path
	p3p_name=`ls *qlcnic*.rpm`
	cd $utils_rpm_path
	p3_utils_name=`ls *nx_nic-tools*rpm`
	if [ -f "$p3_utils_name" ]; then
		echo "Installing new p3 nx_nic-tools: $p3_utils_name"
		rpm -ivh $utils_rpm_path/$p3_utils_name >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "ERROR: nx_nic-tools installatuion failed"
		else
			echo "PASS: nx_nic-tools installed successfully"
		fi
	else
		echo "ERROR: nx_nic-tools rpm is not present on local filesystem"
	fi
	cd $driver_rpm_path
	if [ -f "$p3_name" ]; then
		echo "Installing new p3 driver: $p3_name"
		rpm -ivh $driver_rpm_path/$p3_name >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "ERROR: nx_nic installatuion failed"
		else
			echo "PASS: nx_nic installed successfully"
			nxnic_new_version=$(get_driver_version nx_nic)
		fi
	else
		echo "ERROR: nx_nic rpm is not present in local disk"
	fi
	if [ -f "$xport_name" ]; then
		echo "Installing new xport driver: $xport_name"
		rpm -ivh $driver_rpm_path/$xport_name >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "ERROR: nx_xport installatuion failed"
		else
			echo "PASS: nx_xport installed successfully"
		fi
	fi
	if [ -f "$p3p_name" ]; then
		echo "Installing new qlcnic driver: $p3p_name"
		rpm -ivh --nodeps $driver_rpm_path/$p3p_name >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "ERROR: qlcnic installatuion failed"
		else
			echo "PASS: qlcnic installed successfully"
		fi
	fi
elif [ "$OEM" == "2"  ]; then  # DELL TAURUS
	installed_nic_package=`rpm -qa | grep qlcnic`
	installed_qlge_package=`rpm -qa | grep qlge`
	echo "Uninstalling following old NIC RPM packages"
	if [ -n "$installed_nic_package" ]; then
		echo "         $installed_nic_package"
		rpm -e $installed_nic_package >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "		ERROR: uninstallation failed"
		fi
	fi
	if [ -n "$installed_qlge_package" ]; then
		echo "         $installed_qlge_package"
		rpm -e $installed_qlge_package >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "		ERROR: uninstallation failed"
		fi
	fi
	nic_path="$dut_drop_latest_path/driver/rpm"
	cd $nic_path
	if echo $OS_NAME | grep -E "rhel5|sles10" >/dev/null; then
		qlcnic_name=`ls qlcnic*rpm`
		qlge_name=`ls qlge*rpm`
	elif [ "$OS_NAME" == "sles11.2" ]; then
		qlcnic_name=`ls qlgc-qlcnic-kmp-$KERNEL_FLAV-*.rpm`
		qlge_name=`ls qlgc-qlge-kmp-$KERNEL_FLAV-*.rpm`
	elif echo $OS_NAME | grep "xs6" >/dev/null; then
		qlcnic_name=`ls qlge-modules-$KERNEL_FLAV-$KKERNEL_VERSION-*rpm`
		qlge_name=`ls qlcnic-modules-$KERNEL_FLAV-$KKERNEL_VERSION-*rpm`
	else
		qlcnic_name=`ls kmod-qlgc-qlcnic-*.rpm`
		qlge_name=`ls kmod-qlgc-qlge-*.rpm`
	fi
	if [ -f "$qlcnic_name" ]; then
		echo "Installing new qlcnic driver: $qlcnic_name"
		rpm -ivh --nodeps $nic_path/$qlcnic_name >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "ERROR: qlcnic installatuion failed"
		else
			echo "PASS: qlcnic installed successfully"
		fi
	fi
	if [ -f "$qlge_name" ]; then
		echo "Installing new qlge driver: $qlge_name"
		rpm -ivh $nic_path/$qlge_name >/dev/null 2>&1
		depmod -a >/dev/null
		if [ $? != 0 ]; then
			echo "ERROR: qlge installatuion failed"
		else
			echo "PASS: qlge installed successfully"
			qlge_new_version=$(get_driver_version qlge)
		fi
	fi
elif [[ "$OEM" == "3" || "$OEM" == "4" ]]; then  # 2013 U1 or HELGA
	NIC_PKG=`ls $dut_drop_latest_path/driver/src/qlcnic*tgz`
	if [ -f "$NIC_PKG"  ]; then
		cd $dut_drop_latest_path/driver/src/
        	tar xvf $NIC_PKG >/dev/null
		rm -rf $NIC_PKG
	        cd qlcnic*
               	if [ -f qlcnic-src-install.sh ]; then
                        ./qlcnic-src-install.sh -b >/dev/null
                       	./qlcnic-src-install.sh -i >/dev/null
			echo "PASS: qlcnic installed successfully"
		else
			echo "ERROR: qlcnic driver installation failed, install it manually"
		fi
	fi
	if [ "$OEM" == "3" ]; then
		QLGE_PKG=`ls $dut_drop_latest_path/driver/src/qlge*tgz`
		if [ -f "$QLGE_PKG" ]; then
			cd $dut_drop_latest_path/driver/src
	        	tar xvf $QLGE_PKG >/dev/null
			rm -rf $QLGE_PKG
		        cd qlge*
			make -C /lib/modules/$(uname -r)/build M=$(pwd) modules CONFIG_QLGE=m >/dev/null
			if [ "$OS" == "SLES" ]; then
				make -C /lib/modules/$(uname -r)/build M=$(pwd) INSTALL_MOD_DIR=updates/ modules_install >/dev/null
			else #RHEL
				make -C /lib/modules/$(uname -r)/build M=$(pwd) modules_install >/dev/null
			fi
			depmod -a >/dev/null
			qlge_new_version=$(get_driver_version qlge)
		fi
		
	fi
fi
depmod -a >/dev/null
qlcnic_new_version=$(get_driver_version qlcnic)
################################3##############
#	Qla2xxx Driver Installation	
###############################################
echo "===================================="
echo "    INFO: Installing qla2xxx        "
echo "===================================="
qla2xxx_old_version=$(get_driver_version qla2xxx)
if [ "$OEM" == "1"  ]; then  # HP 1090
	installed_qla2xxx_package=`rpm -qa | grep qla2xxx`
	if [ -n "$installed_qla2xxx_package" ]; then
		echo "Uninstalling old qla2xxx package: $installed_qla2xxx_package"
		rpm -e $installed_qla2xxx_package >/dev/null 2>&1
	fi
	qla2xxx_path="$dut_drop_latest_path/driver/rpm"
	cd $qla2xxx_path
	qla2xxx_name=`ls *hpqlgc-qla2xxx*rpm`
	if [ -f "$qla2xxx_name" ]; then
		echo "Installing new qla2xxx driver: $qla2xxx_name"
		rpm -ivh --nodeps $qla2xxx_path/$qla2xxx_name >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "ERROR: qla2xxx installatuion failed"
		else
			echo "PASS: qla2xxx installed successfully"
		fi
	else
		echo "ERROR: qla2xxx rpm is not present on local path: $qla2xxx_path"
	fi
elif [ "$OEM" == "2"  ]; then  # DELL TAURUS
	installed_qla2xxx_package=`rpm -qa | grep qla2xxx`
	if [ -n "$installed_qla2xxx_package" ]; then
		echo "Uninstalling old qla2xxx package $installed_qla2xxx_package"
		rpm -e $installed_qla2xxx_package >/dev/null 2>&1
	fi
	qla2xxx_path="$dut_drop_latest_path/driver/rpm"
	cd $qla2xxx_path
	if echo $OS_NAME | grep -E "rhel5|sles10" >/dev/null; then
		qla2xxx_name=`ls qla2xxx*rpm`
	elif [ "$OS_NAME" == "sles11.2" ]; then
		qla2xxx_name=`ls qlgc-qla2xxx-kmp-$KERNEL_FLAV-*.rpm`
	elif echo $OS_NAME | grep "xs6" >/dev/null; then
		qla2xxx_name=`ls qla2xxx-modules-$KERNEL_FLAV-$KKERNEL_VERSION-*rpm`
	else
		qla2xxx_name=`ls kmod-qlgc-qla2xxx-*.rpm`
	fi
	if [ -f "$qla2xxx_name" ]; then
		echo "Installing new qla2xxx driver: $qla2xxx_name"
		rpm -ivh $qla2xxx_path/$qla2xxx_name >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "ERROR: qla2xxx installatuion failed"
		else
			echo "PASS: qla2xxx installed successfully"
		fi
	else
		echo "ERROR: qla2xxx rpm is not present on local path: $qla2xxx_path"
	fi
elif [[ "$OEM" == "3" || "$OEM" == "4"  ]]; then  # 2013_U1 or  HELGA
	FCOE_PKG=`ls $dut_drop_latest_path/driver/src/qla2xxx*tar.gz`
	if [ -f "$FCOE_PKG"  ]; then
		cd $dut_drop_latest_path/driver/src/
        	tar xvf $FCOE_PKG >/dev/null
		rm -rf $FCOE_PKG
	        cd qla2xx*
	        if [ -f extras/build.sh ]; then
        	        ./extras/build.sh clean > /dev/null
	                ./extras/build.sh new >/dev/null
        	        ./extras/build.sh install > /dev/null
	                ./extras/build.sh initrd > /dev/null
			echo "PASS: qla2xxx installed successfully"
		else
			echo "ERROR: qla2xxx driver installation failed, install it manually"
		fi
	else
		echo "ERROR: qla2xxx: couldn't find the latest package. Please install it manually"
	fi
fi
qla2xxx_new_version=$(get_driver_version qla2xxx)
################################3##############
#	Qla4xxx Driver Installation	
###############################################
echo "===================================="
echo "    INFO: Installing qla4xxx        "
echo "===================================="
qla4xxx_old_version=$(get_driver_version qla4xxx)
if [ "$OEM" == "1"  ]; then  # HP 1090
	installed_qla4xxx_package=`rpm -qa | grep qla4xxx`
	if [ -n "$installed_qla4xxx_package" ]; then
		echo "Uninstalling old qla4xxx package: $installed_qla4xxx_package"
		rpm -e $installed_qla4xxx_package > /dev/null 2>&1
	fi
	qla4xxx_path="$dut_drop_latest_path/driver/rpm"
	cd $qla4xxx_path
	qla4xxx_name=`ls *hpqlgc-qla4xxx*rpm`
	if [ -f "$qla4xxx_name" ]; then
		echo "Installing new qla4xxx driver: $qla4xxx_name"
		rpm -ivh $qla4xxx_path/$qla4xxx_name >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "ERROR: qla4xxx installatuion failed"
		else
			echo "PASS: qla4xxx installed successfully"
		fi
	else
		echo "ERROR: qla4xxx rpm is not present on local path: $qla4xxx_path"
	fi
elif [ "$OEM" == "2"  ]; then  # DELL TAURUS
	installed_qla4xxx_package=`rpm -qa | grep qla4xxx`
	if [ -n "$installed_qla4xxx_package" ]; then
		echo "Uninstalling old qla4xxx rpm package $installed_qla4xxx_package"
		rpm -e $installed_qla4xxx_package > /dev/null 2>&1
	fi
	qla4xxx_path="$dut_drop_latest_path/driver/rpm"
	cd $qla4xxx_path
	if echo $OS_NAME | grep -E "rhel5|sles10" >/dev/null; then
		qla4xxx_name=`ls qla4xxx*rpm`
		#rpm -ivh $dut_drop_latest_path/Driver/qla4xxx*rpm >/dev/null 2>&1
	elif [ "$OS_NAME" == "sles11.2" ]; then
		qla4xxx_name=`ls qlgc-qla4xxx-kmp-$KERNEL_FLAV-*.rpm`
		#rpm -ivh $dut_drop_latest_path/Driver/qlgc-qla4xxx-kmp-$KERNEL_FLAV-*.rpm >/dev/null 2>&1
	elif echo $OS_NAME | grep "xs6" >/dev/null; then
		qla4xxx_name=`ls qla4xxx-modules-$KERNEL_FLAV-$KKERNEL_VERSION-*rpm`
		#rpm -ivh $dut_drop_latest_path/Driver/qla4xxx-modules-$KERNEL_FLAV-$KKERNEL_VERSION-*rpm >/dev/null 2>&1
	else
		qla4xxx_name=`ls kmod-qlgc-qla4xxx-*.rpm`
		#rpm -ivh $dut_drop_latest_path/Driver/kmod-qlgc-qla4xxx-*.rpm >/dev/null 2>&1
	fi
	if [ -f "$qla4xxx_name" ]; then
		echo "Installing new qla4xxx driver: $qla4xxx_name"
		rpm -ivh $qla4xxx_path/$qla4xxx_name >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "ERROR: qla4xxx installation failed"
		else
			echo "PASS: qla4xxx installed successfully"
		fi
	else
		echo "ERROR: qla2xxx rpm is not present on local path: $qla4xxx_path"
	fi
elif [[ "$OEM" == "3" || "$OEM" == "4"  ]]; then  # 2013_U1 or  HELGA
	ISCSI_PKG=`ls $dut_drop_latest_path/driver/src/qla4xxx*tar.gz`
	if [ -f "$ISCSI_PKG"  ]; then
		cd $dut_drop_latest_path/driver/src/
        	tar xvf $ISCSI_PKG >/dev/null
		rm -rf $ISCSI_PKG
	        cd qla4xxx*
	        if [ -f extras/build.sh ]; then
        	        ./extras/build.sh clean > /dev/null
	                ./extras/build.sh new >/dev/null
        	        ./extras/build.sh install > /dev/null
	                ./extras/build.sh initrd > /dev/null 2>&1
			echo "PASS: qla4xxx installed successfully"
		else
			echo "ERROR: qla4xxx driver installation failed, install it manually"
		fi
	else
		echo "ERROR: qla4xxx: couldn't find the latest package. Please install it manually"
	fi
fi
qla4xxx_new_version=$(get_driver_version qla4xxx)
#########################################################
#		QCC Installation		 	#
#########################################################
echo "===================================="
echo "    INFO: Installing qaucli         "
echo "===================================="
installed_qaucli_package=`rpm -qa | grep QConvergeConsoleCLI`
if [ -n "$installed_qaucli_package" ]; then
	qcc_old_version=$(get_driver_version qcc)
	echo "Uninstalling old qaucli package $installed_qaucli_package"
	rpm -e $installed_qaucli_package >/dev/null  2>&1
fi
if [[  "$OEM" == "1" || "$OEM" == "2" || "$OEM" == "3" || "$OEM" == "4"  ]]; then  # HP1090 or DELL TAURUS or  2013_U1 or  HELGA
	QCC_PATH="$dut_drop_latest_path/qcc_cli"
	cd $QCC_PATH
	new_qaucli_package=`ls QConvergeConsoleCLI*rpm`
	#if [ "$installed_qaucli_package" == $new_qaucli_package  ]; then
	#	echo "No changes "
	#fi
	echo "Installing the new qaucli package: $new_qaucli_package"
	if [ -f $QCC_PATH/QConvergeConsoleCLI*rpm ]; then
		rpm -ivh $QCC_PATH/QConvergeConsoleCLI*rpm >/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "ERROR: qaucli installation failed"
		else
			echo "PASS: qaucli installed successfully"
		fi
	else
		echo "ERROR: qaucli rpm is not present on local disk: $QCC_PATH"
	fi
fi
qcc_new_version=$(get_driver_version qcc)

#########################################################
#	QCC Remote Agent Installation		 	#
#########################################################
echo "================================================="
echo "  INFO: Installing the QCC Remote agents"
echo "================================================="
if [[  "$OEM" == "1" || "$OEM" == "2" || "$OEM" == "3" || "$OEM" == "4"  ]]; then  # HP1090 or DELL TAURUS or  2013_U1 or  HELGA
	rpm -qa >/tmp/rpm_all_list
	netqlremote_rpm=`cat /tmp/rpm_all_list | grep ^netqlremote`
	qlremote_rpm=`cat /tmp/rpm_all_list | grep ^qlremote`
	iqlremote_rpm=`cat /tmp/rpm_all_list | grep ^iqlremote`
	if [ -n "$netqlremote_rpm" ]; then
		netqlremote_old_version=`echo $netqlremote_rpm | sed s/netqlremote-//g`
		echo "uninstalling old netqlremote agent rpm: $netqlremote_rpm"
		rpm -e $netqlremote_rpm > /dev/null 2>&1
	fi
	if [ -n "$qlremote_rpm" ]; then
		qlremote_old_version=`echo $qlremote_rpm | sed s/qlremote-//g`
		echo "uninstalling old qlremote agent rpm: $qlremote_rpm"
		rpm -e $qlremote_rpm > /dev/null 2>&1
	fi
	if [ -n "$netqlremote_rpm" ]; then
		iqlremote_old_version=`echo $iqlremote_rpm | sed s/iqlremote-//g`
		echo "uninstalling old iqlremote agent rpm: $iqlremote_rpm"
		rpm -e $iqlremote_rpm > /dev/null 2>&1
	fi
	cd  $dut_drop_latest_path/qcc_remote_agent
	echo "Installing netqlremote rpm: `ls netqlremote*rpm`"
	rpm -ivh netqlremote*rpm > /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "ERROR: netqlremote installation failed"
	else
		echo "PASS: netqlremote installed successfully"
	fi
	echo "Installing qlremote rpm: `ls qlremote*rpm`"
	rpm -ivh qlremote*rpm > /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "ERROR: qlremote installation failed"
	else
		echo "PASS: qlremote installed successfully"
	fi
	echo "Installing iqlremote rpm: `ls iqlremote*rpm`"
	rpm -ivh iqlremote*rpm > /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "ERROR: iqlremote installation failed"
	else
		echo "PASS: iqlremote installed successfully"
	fi
	rpm -qa >/tmp/rpm_all_list
	netqlremote_new_version=`cat /tmp/rpm_all_list | grep ^netqlremote | sed s/netqlremote-//g`
	qlremote_new_version=`cat /tmp/rpm_all_list | grep ^qlremote | sed s/qlremote-//g`
	iqlremote_new_version=`cat /tmp/rpm_all_list | grep ^iqlremote | sed s/iqlremote-//g`
fi

#########################################################
#		Utils Installation		 	#
#########################################################
echo "================================================="
echo "  INFO: Installing the qlogic utils"
echo "================================================="
if [ "$OEM" == "1"  ]; then  # HP 1090
	installed_utils_pkg=`rpm -qa | grep hp-nx_nic`
	if [ -n "$installed_utils_pkg" ]; then
		tools_old_version=`echo $installed_utils_pkg | sed s/hp-nx_nic-tools-//g`
		echo "uninstalling old qlogic tools rpm: $installed_utils_pkg"
		rpm -e $installed_utils_pkg > /dev/null 2>&1
	fi
	cd $dut_drop_latest_path/utils/
	new_utils_pkg=`ls hp-nx_nic*rpm`
	echo "Installing new qlogic tools rpm: $new_utils_pkg"
	rpm -ivh $new_utils_pkg > /dev/null 2>&1
	if [ $? != 0 ]; then
		echo "ERROR: Tools installation failed"
	else
		echo "PASS: Tools installed successfully"
	fi
	tools_new_version=`rpm -qa | grep hp-nx_nic | sed s/hp-nx_nic-tools-//g`
elif [ "$OEM" == "2"  ]; then  # DELL TAURUS
	#installed_utils_package=`rpm -qa | grep qlgc-utils`
	#echo "Uninstalling qlogic utils package $installed_utils_package, before proceeding with latest utils installation"
	#rpm -e $installed_utils_package >/dev/null
	cd  $dut_drop_latest_path/utils/
	new_utils_package=`ls qlgc-utils*rpm`
	echo "Installing the new utils package: $new_utils_package"
	rpm -ivh $dut_drop_latest_path/utils/qlgc-utils*rpm >/dev/null 2>&1
	if [ $? != 0 ]; then
		echo "ERROR: Utils installation failed"
	else
		echo "PASS: utils installed successfully"
	fi
else
	echo "Qlogic utils are not avilable for current drop"
fi

#########################################################
#		FW Installation		 	#
#########################################################
echo "===================================="
echo "    INFO: Upgrading the Firmware"
echo "===================================="
##	reload the latest nic driver
/etc/init.d/netqlremote stop >/dev/null
rmmod qlcnic
modprobe qlcnic
if [ "$OEM" == "2"  ]; then  # DELL TAURUS
	cd $dut_drop_latest_path/fw
	
	for i in `ls *tar.gz`
	do
		echo "Upgrading the FW Package $i"
		rm -rf temp
		mkdir -p temp
		cd temp
		tar xvf ../$i >/dev/null
		./update.sh
		cd ..
	done
elif [ "$OEM" == "4"  ]; then  # HELGA
	if lsmod | grep qlcnic > /dev/null ; then
		### Get old FW version and qcc inst number
		qaucli -pr nic -i | grep -A3 "CNA Physical Port: 1) CNA Model: QLE8442"  > /tmp/qaucli.output
		old_fw_version=`cat /tmp/qaucli.output  | grep "FW Ver" | awk '{print $9}'`
		qcc_inst_no=`cat /tmp/qaucli.output  | grep "CNA Model" | awk -F . '{ gsub (" ","", $1); print $1}'`
		cd $dut_drop_latest_path/fw
		fw_pkg_name=`ls *zip | sed s/.zip//g`
		if [ -n "$fw_pkg_name" ]; then
			mkdir -p $fw_pkg_name
			cd $fw_pkg_name
			unzip ../*.zip
			rm -rf ../*.zip
			qaucli -pr nic -flashsupport -i all -a *.bin > /dev/null
			if [ $? != 0 ]; then
				echo "ERROR: FW update failed"
			else
				echo "PASS: FW updated successfully"
			fi
		fi
	else
		echo "ERROR: qlcnic driver is not loaded, Upgrade the FW manually"
	fi
else
	echo "FW upgrade is not implemented, upgrade it manually"
fi

depmod -a > /dev/null


echo "===================================================================="
echo "      Driver and Application installation Completed for $OEM_NAME"
echo "==================================================================="
echo "------------------------------------------------------------------------"
printf "|  %12s  |  %22s  |  %22s  |\n" "Driver/Apps" "Old Version" "Updated Version"
echo "|----------------|--------------------------|--------------------------|"
printf "|  %12s  |  %22s  |  %22s  |\n" "qlcnic" $qlcnic_old_version  $qlcnic_new_version
printf "|  %12s  |  %22s  |  %22s  |\n" "qla2xxx" $qla2xxx_old_version $qla2xxx_new_version
printf "|  %12s  |  %22s  |  %22s  |\n" "qla4xxx" $qla4xxx_old_version $qla4xxx_new_version
if [ "$OEM" == "$1" ]; then # HP 1090
printf "|  %12s  |  %22s  |  %22s  |\n" "nx_nic" $nxnic_old_version $nxnic_new_version
elif [[ "$OEM" == "2" || "$OEM" == "3" ]]; then # DELL TAURUS or 2013 U1
printf "|  %12s  |  %22s  |  %22s  |\n" "qlge" $qlge_old_version $qlge_new_version
fi
printf "|  %12s  |  %22s  |  %22s  |\n" "QCC_CLI" $qcc_old_version $qcc_new_version
printf "|  %12s  |  %22s  |  %22s  |\n" "netqlremote" $netqlremote_old_version $netqlremote_new_version
printf "|  %12s  |  %22s  |  %22s  |\n" "qlremote" $qlremote_old_version $qlremote_new_version
printf "|  %12s  |  %22s  |  %22s  |\n" "iqlremote" $iqlremote_old_version $iqlremote_new_version
if [[ "$OEM" == "1" ]]; then # HP1090
printf "|  %12s  |  %22s  |  %22s  |\n" "nx_nic-tools" $tools_old_version $tools_new_version
fi
echo "------------------------------------------------------------------------"

