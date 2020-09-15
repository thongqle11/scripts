#!/usr/bin/env python

#Auhtor: Eugene Cho (echo@broadcom.com)
#
#This script collects the Linux based system's information including
#    - !Hostname
#    - System Name
#    - !Kernel Name
#    - CPU type
#    - RAM size
#    - !OS Name
#    - !Platform
#    - bnx2x version
#    - bnx2fc version
#    - CNIC version
#
#    Modified by Travis Taylor to make standalone
#    travis.taylor@qlogic.com 
#'''

DEVICE_MAPPING = {
                  '0x007c': {'modelname': 'MONTERAS', 'mf_mode': 'AFEX'},  # Montera S
                  '0x0087': {'modelname': 'A1213G', 'mf_mode': 'AFEX'},    # Punisher 2
                  '0x045f': {'modelname': 'A1288G', 'mf_mode': 'NPAR'},    # Wocket
                  '0x3382': {'modelname': 'Benavides', 'mf_mode': 'FFA'}, # HP Benavides ALOM
                  '0x1006': {'modelname': 'Quark', 'mf_mode': 'NPAR'},     # Jupiter Dell (Quark)
                  '0x5006': {'modelname': 'Jupiter', 'mf_mode': 'NPAR'},   # Jupiter
                  '0x339d': {'modelname': 'Bastrop', 'mf_mode': 'FFA'},   # Jupiter HP (Bastrop)
                  '0x1008': {'modelname': 'Saturn', 'mf_mode': 'N/A'},    # Saturn
                  '0x18d3': {'modelname': 'Sundown', 'mf_mode': 'FFA'},   # Saturn HP (Sundown)
                  '0x1f5c': {'modelname': '57800', 'mf_mode': 'NPAR'},     # Dell Anara or 57800 Mission Board
                  '0x1f67': {'modelname': '57800', 'mf_mode': 'NPAR'},     # Dell Anara (1Gb?)
                  '0x1007': {'modelname': 'Ensign Ro', 'mf_mode': 'NPAR'}, # Ensign-Ro
                  '0x052a': {'modelname': 'Hifi', 'mf_mode': 'NPAR'},      # Hifi
                  '0x1f5f': {'modelname': 'Nog', 'mf_mode': 'NPAR'},
                  '0x1f5d': {'modelname': 'Okala', 'mf_mode': 'NPAR'},
                  '0x1f68': {'modelname': 'Okala', 'mf_mode': 'NPAR'},
                  '0x1798': {'modelname': 'Bailey', 'mf_mode': 'FFA'},
                  '0x17a5': {'modelname': 'Bayview', 'mf_mode': 'FFA'},
                  '0x1916': {'modelname': 'Baird', 'mf_mode': 'FFA'},
                  '0x1917': {'modelname': 'Brownwood', 'mf_mode': 'FFA'},
                  '0x22fa': {'modelname': 'Breezy', 'mf_mode': 'FFA'},
                  '0x00cb': {'modelname': 'A1006G Cisco', 'mf_mode': 'AFEX'},
                  '0x193a': {'modelname': 'Bryan', 'mf_mode': 'NPAR'},
                  '0x1930': {'modelname': 'Benavides2', 'mf_mode': 'NPAR'},
                  '0x1931': {'modelname': 'Barracuda', 'mf_mode': 'NPAR'},
                  '0x1932': {'modelname': 'Bailey2', 'mf_mode': 'FFA'},
                  '0x1933': {'modelname': 'Bayview2', 'mf_mode': 'FFA'}
		}

short_name = True

import platform, re, sys, os
import subprocess as sp


def run_command(cmd,ishell=True):
    handle = sp.Popen(cmd,shell=ishell,stdout=sp.PIPE,stderr=sp.PIPE)
    sout,serr = handle.communicate()
    return (handle.returncode,sout,serr)

    #returns dictionary of interfaces to macs

def get_all_interfaces(driver_filter=None):
    ret,out,err = run_command('ip link')
    outd = {}
    #should be a way to grab all interfaces from here instead of doing two regex runs
    for iface in re.findall('^[0-9]+: ([^:]+):.*?(?!^[0-9]+:)',out,flags=re.MULTILINE | re.DOTALL):
        ret,out,err = run_command('ip link show %s' % iface)
        ret = re.search('link/ether ([^\s]+)',out,flags=re.MULTILINE)
        if ret is not None:
            if driver_filter is not None:
                _,out2,_ = run_command('ethtool -i %s' % iface)
                res = re.search('driver: ([^\s]+)$',out2,flags=re.MULTILINE)
                if res is not None and res.groups()[0] == driver_filter:
                    outd[iface] = ret.groups()[0]
            else:
                outd[iface] = ret.groups()[0]
    return outd
            
def dmidecode(request_type):
    #if not exe.block_run('which dmidecode', True)[0]:
    if run_command('which dmidecode')[0] != 0:
        print 'Error: Can\'t find dmidecode!'
        return None
    
    if request_type == 'system_name':
        try:
            return re.search('Product Name: (.*)', os.popen('dmidecode -t system').read()).group(1)
        except:
            return 'N/A'
    
    elif request_type == 'cpu':
        try:
            for cpu in re.findall('Version: (.*)', os.popen('dmidecode -t processor').read()):
                if not cpu == 'Not specified':
                    return cpu
        except:
            return 'N/A'

def get_sub_device_id_by_bus(bus_id):
    ret,out,_ = run_command('udevadm info --export-db')
    if ret != 0:
        print 'Failed to call udevadm'
	sys.exit(1)
    for item in out.split('\n\n'):
        if re.search('SUBSYSTEM=net',item,flags=re.MULTILINE) is not None:
	    path = re.search('DEVPATH=([^\s]+)$',item,flags=re.MULTILINE).groups()[0]
            path = '/'.join(path.split('/')[:-2])
            #bus = re.search('NET_MATCHID=([^\s]+)$',item,flags=re.MULTILINE).groups()[0]
            bus = path.split('/')[-1]
            shortbus = bus
            if bus.startswith('0000:'):
                shortbus = bus[5:]
            if shortbus == bus_id:
                subdevice_path = os.path.join('/sys',path,'subsystem_device')
		subdevice_path = '/sys' + subdevice_path #hack
                return open(subdevice_path,'rb').read().strip()
    return 'Unknown Bnx2x'.strip()
               
	    

def get_driver_version(driver_name):
    try:
        #version = info.get_driver_version(driver_name)
        program_out = run_command('modinfo %s' % driver_name)
        mat = re.search('version:\s+([^\s]+)',program_out[1],flags=re.MULTILINE)
        if mat is None:
            return 'N/A'
        else: 
            return mat.groups()[0]
    except:
        return 'N/A'
    else:
        if version == False:
            return 'N/A'

    
    return version

def get_bootcode(driver='bnx2x',interface=None):
    #pick a random bnx2x driver and return the firmware-version
    #eth = eth_info.get_bnx2x_eth()
    interface_names = []
    if interface is None:
        interface_names = sorted(get_all_interfaces().keys())
    else:
        interface_names = [interface]
        
    for iface in interface_names:
        ret,out,err = run_command('ethtool -i %s' % iface)
        res = re.search('driver: ([^\s]+)$.*?firmware-version: (.*?)$',out,flags=re.MULTILINE |re.DOTALL)
        if res is not None and res.groups()[0] == driver:
            return res.groups()[1]
    return 'N/A'

def get_bus(interface):
    ret,out,err = run_command('ethtool -i %s' % interface)
    res = re.search('bus-info: ([^\s]+)$',out,flags=re.MULTILINE)
    if res is not None:
        out = res.groups()[0]
        if out.startswith('0000:'):
            return out[5:]
        else:
            return out
    else:
        return 'N/A'

def get_model(bus_id):
    subdevice = get_sub_device_id_by_bus(bus_id)
    global DEVICE_MAPPING
    if subdevice in DEVICE_MAPPING.keys():
        return DEVICE_MAPPING[subdevice]['modelname']
    else:
        return 'Unknown BNX2X card (%s)' % (subdevice)


def old_get_model(bus_id):
    ret,out,err = run_command('lspci -s %s -mm' % bus_id)
    if ret != 0:
        print 'Failure to call lspci (%d)!' % ret
	sys.exit(1)
    fields = ' '.join(out.split(' ')[1:])
    return re.findall('"[^"]*?"',fields)[2]

def shorten_name(name):
    res = re.search('NetXtreme II ([^\s]*) 10 Gigabit Ethernet',name)
    if res is not None:
        return res.groups()[0]
    return name

def get_board_info(driver_name='bnx2x'):
    ret_info = {'model': [], 'bootcode': []}
    temp_info = {}

    #find all BNX2X cards
    for iface in sorted(get_all_interfaces(driver_filter=driver_name).keys()):
        model = get_model(get_bus(iface))
        if model not in ret_info['model']:
            ret_info['model'].append(get_model(get_bus(iface)))
            ret_info['bootcode'].append(get_bootcode(driver=driver_name,interface=iface))
    global short_name
    if short_name:
        ret_info['model'] = [shorten_name(x) for x in ret_info['model']]
    return ret_info

        
    
    
    #for eth, pcibus in eth_info.get_pcibus(['bnx2x']).iteritems():
    #    temp_info[pcibus] = {
   #                         'model': eth_info.get_model_by_pcibus(pcibus),
   #                         'eth': eth,
   #                         }

   #     try:
   #         temp_info[pcibus]['bootcode'] = re.search('firmware-version: (.*)', os.popen('ethtool -i %s' %(eth)).read()).group(1)
   #     except:
   #         temp_info[pcibus]['bootcode'] = 'N/A'

    
   # for pcibus, info in temp_info.iteritems():
   #     if not info['model'] in ret_info['model']:
   #         ret_info['model'].append(info['model'])
   #         ret_info['bootcode'].append(info['bootcode'])
    
    
    return ret_info

def get_sysinfo():
    sys_info = {}
    board_info = get_board_info()
    
    # Get the hostname
    sys_info['Hostname'] = platform.node()
    sys_info['Kernel'] = platform.release()
    sys_info['OS'] = '-'.join(platform.linux_distribution())
    sys_info['Architecture'] = platform.architecture()[0]
    
    try:
        sys_info['Memory'] = re.search('MemTotal:\s+(\d+ kB)', open('/proc/meminfo', 'r').read()).group(1)
    except:
        sys_info['Memory'] = 'N/A'
        
    sys_info['bnx2x'] = get_driver_version('bnx2x')
    sys_info['bnx2fc'] = get_driver_version('bnx2fc')
    sys_info['cnic'] = get_driver_version('cnic')
    sys_info['bnx2i'] = get_driver_version('bnx2i')
    sys_info['bootcode'] = ', '.join(board_info['bootcode']) 
    #sys_info['bootcode'] = get_bootcode()
    sys_info['Server Type'] = dmidecode('system_name')
    sys_info['CPU'] = dmidecode('cpu')
    sys_info['Board'] = ', '.join(board_info['model'])
    #sys_info['Board'] = ', '.join({}.fromkeys([ eth_info.get_model_by_pcibus(pcibus) for pcibus in eth_info.get_pcibus(['bnx2x']).values() ]).keys()) # Hide 1Gb 
    return sys_info    
    
def main():
    info_list = ['Hostname',
                 'Server Type',
                 'CPU',
                 'Memory',
                 'OS',
                 'Kernel',
                 'Architecture',
                 'Board',
                 'bootcode',
                 'cnic',
                 'bnx2x',
                 'bnx2fc',
                 'bnx2i',
                 ]
    
    sysinfo = get_sysinfo()
    for info in info_list:
        print info.ljust(15) + ': ' + sysinfo[info] 

if __name__ == '__main__':
    sys.exit(main())
