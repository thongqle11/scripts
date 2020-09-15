#!/bin/sh
if [ $1 = "udp" ];then
	arg=m31
else
	arg=m30
fi

clear
echo "Enter name of inteface:"
read int1

echo "Enter IP of test interface:"
read src_ip
#src_ip=192.168.1.73

echo "Enter IP to run sock to:"
read test_ip
#test_ip=192.168.1.158
clear
if [ $arg == "m31" ]; then
	echo "************UDP Test**************"
	while true; do
  	  for MTU in 512 1024 1500 2048 9000 9600;do
            echo "$(date) : ifconfig $int1 mtu $MTU"
            ifconfig $int1 mtu $MTU
            read -p "     Please change MTU on peer, and press enter when ready... " -n1 -s
	    echo "" 
	    ifconfig $int1 mtu $MTU

            #run sock
            echo "$(date) : Running Medusa sock for 2 minutes"
            sock -M5 -f$src_ip:$test_ip -d120 -$arg &>/dev/null
            sleep 10

            #If bad files are detected, stop test
            if [ -f *.bad ]; then
                echo "$(date) : Medusa test failed"
                echo "$(date) : Stopping test"
                exit 1
            else
                echo "$(date) : Medusa test passed"
            fi
  	    done
	done

else
	echo "************TCP Test**************"
	while true; do
  	  for MTU in 132 512 1024 1500 2048 9000 9600;do
          echo "$(date) : ifconfig $int1 mtu $MTU"
          ifconfig $int1 mtu $MTU

          #run sock
          echo "$(date) : Running Medusa sock for 2 minutes"
          sock -M5 -f$src_ip:$test_ip -d120 -$arg &>/dev/null
          sleep 10

          #If bad files are detected, stop test
          if [ -f *.bad ]
          then
                echo "$(date) : Medusa test failed"
                echo "$(date) : Stopping test"
                exit 1

          else
                echo "$(date) : Medusa test passed"

          fi
          done
        done
fi
