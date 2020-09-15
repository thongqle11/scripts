#!/bin/bash

MyDir=$(pwd)
RemoteIP=172.27.18.146
Remoteqedr=qedr1
RemoteTestIP=192.168.2.146
Localqedr=qedr1
LocalTestIP=192.168.2.148

echo "Choose a test:"
echo "     1: ib_send_bw"
echo "     2: ib_write_bw"
echo "     3: ib_read_bw"
echo "     4: ib_send_lat"
echo "     5: ib_write_lat"
echo "     6: ib_read_lat"
echo "     7: rdma_xserver/rdma_xclient"
echo "     8: rdma_server/rdma_client"
read test

which_subtest () {
echo "Choose a subtest:"
echo "     1: size of MTU"
echo "     2: # of QPs"
echo "     3: message size"
echo "     4: # of iterations"
echo "     5: GID index"
read subtest
}

more_options () {
echo "Any other options?"
echo "     1: Yes"
echo "     2: No"
read option

if [ "$option" == "1" ]; then
    echo "Enter option(s)"
    read argument
elif [ "$option" == "2" ]; then
    :
else
    echo "ERROR: Invalid Argument"
    exit
fi
}

kill_process () {
ssh $RemoteIP "pkill ib_send_bw; pkill ib_write_bw; pkill ib_read_bw; pkill ib_send_lat; pkill ib_write_lat; pkill ib_read_lat; pkill rdma_xserver; pkill rdma_xclient; pkill rdma_server; pkill rdma_client"
pkill ib_send_bw; pkill ib_write_bw; pkill ib_read_bw; pkill ib_send_lat; pkill ib_write_lat; pkill ib_read_lat; pkill rdma_xserver; pkill rdma_xclient; pkill rdma_server; pkill rdma_client
}

change_mtu () {
	echo "Will run $ib_test and mtu test."
        read -p "Press any key to continue... " -n1 -s
        clear
        for mtu_value in 256 512 1024 2048 4096; do
                echo "*********************************************************"
                echo "*********************************************************"
                echo "Testing with MTU of $mtu_value."
                echo "*********************************************************"
                echo "*********************************************************"
                ssh -f $RemoteIP "$ib_test -F -x 0 -d $Remoteqedr -m $mtu_value $argument"
                sleep 1
                echo "$ib_test -F -x 0 -d $Localqedr $RemoteTestIP -m $mtu_value $argument"
                $ib_test -F -x 0 -d $Localqedr $RemoteTestIP -m $mtu_value $argument
                sleep 1
        done
}
qp_test () {	
	echo "Will run $ib_test and qp test."
	read -p "Press any key to continue... " -n1 -s
	clear
	for qp_value in 1 2 4 8 16 32 64 128 256 512 1024; do
        	echo "*********************************************************"
        	echo "*********************************************************"
        	echo "Testing with $qp_value QPs"
        	echo "*********************************************************"
        	echo "*********************************************************"
        	ssh -f $RemoteIP "$ib_test -F -x 0 -d $Remoteqedr -q $qp_value $argument"
        	sleep 1
        	echo "$ib_test -F -x 0 -d $Localqedr $RemoteTestIP -q $qp_value $argument"
        	$ib_test -F -x 0 -d $Localqedr $RemoteTestIP -q $qp_value $arugment
        	sleep 1
	done
}
message_size () {
	echo "Will run $ib_test and message size test."
        read -p "Press any key to continue... " -n1 -s
        clear
        for message in 1 2 4 8 16 32 64 128 256 512 1024; do
                echo "*********************************************************"
                echo "*********************************************************"
                echo "Testing with message size of $message."
                echo "*********************************************************"
                echo "*********************************************************"
                ssh -f $RemoteIP "$ib_test -F -x 0 -d $Remoteqedr -s $message $argument"
                sleep 1
                echo "$ib_test -F -x 0 -d $Localqedr $RemoteTestIP -s $message $argument"
                $ib_test -F -x 0 -d $Localqedr $RemoteTestIP -s $message $argument
                sleep 1
        done
}
iteration_test () { 
	echo "Will run $ib_test and iteration test."
        read -p "Press any key to continue... " -n1 -s
        clear
        for iter in 5 500 1000 2000 5000 10000 100000 1000000; do
                echo "*********************************************************"
                echo "*********************************************************"
                echo "Testing with $iter iterations."
                echo "*********************************************************"
                echo "*********************************************************"
                ssh -f $RemoteIP "$ib_test -F -x 0 -d $Remoteqedr -n $iter $argument"
                sleep 1
                echo "$ib_test -F -x 0 -d $Localqedr $RemoteTestIP -n $iter $argument"
                $ib_test -F -x 0 -d $Localqedr $RemoteTestIP -n $iter $argument
                sleep 1
        done
}
gid_index () { 
	echo "Will run $ib_test and GID Index test."
        read -p "Press any key to continue... " -n1 -s
        clear
        for gid in 0 1 2 4 8 16 32 64; do
                echo "*********************************************************"
                echo "*********************************************************"
                echo "Testing with GID Index of $gid."
                echo "*********************************************************"
                echo "*********************************************************"
                ssh -f $RemoteIP "$ib_test -F -x 0 -d $Remoteqedr -x $gid $argument"
                sleep 1
                echo "$ib_test -F -x 0 -d $Localqedr $RemoteTestIP -x $gid $argument"
                $ib_test -F -x 0 -d $Localqedr $RemoteTestIP -x $gid $argument
                sleep 1
        done
}
rdma_xserver_rdma_xclient () {
	echo "Will run rdma_xserver and rdma_xclient test."
	echo "How many iterations?"
	read total
	if ! [[ $total =~ ^[0-9]+$ ]]; then
		echo "Invalid input"
		exit
	else
		:
	fi
        read -p "Press any key to continue... " -n1 -s
        clear
	kill_process
	for (( i=1; i <= $total; i++ )); do
                echo "*********************************************************"
                echo "*********************************************************"
                echo "Test $i of $total."
                echo "*********************************************************"
                echo "*********************************************************"
                ssh -f $RemoteIP "rdma_xserver $argument"
                sleep 1
                echo "rdma_xclient -s $RemoteTestIP $argument"
                rdma_xclient -s $RemoteTestIP $argument
                sleep 1
        done
}

rdma_server_rdma_client () {
        echo "Will run rdma_server and rdma_client test."
        echo "How many iterations?"
        read total
        if ! [[ $total =~ ^[0-9]+$ ]]; then
                echo "Invalid input"
                exit
        else
                :
        fi
        read -p "Press any key to continue... " -n1 -s
        clear
        kill_process
        for (( i=1; i <= $total; i++ )); do
                echo "*********************************************************"
                echo "*********************************************************"
                echo "Test $i of $total."
                echo "*********************************************************"
                echo "*********************************************************"
                ssh -f $RemoteIP "rdma_server $argument"
                sleep 1
                echo "rdma_client -s $RemoteTestIP $argument"
                rdma_client -s $RemoteTestIP $argument
                sleep 1
        done
}


if [ "$test" == "1" ]; then
    ib_test=ib_send_bw
    which_subtest
    more_options
elif [ "$test" == "2" ]; then
    ib_test=ib_write_bw
    which_subtest
    more_options
elif [ "$test" == "3" ]; then
    ib_test=ib_read_bw
    which_subtest
    more_options
elif [ "$test" == "4" ]; then
    ib_test=ib_send_lat
    which_subtest
    more_options
elif [ "$test" == "5" ]; then
    ib_test=ib_write_lat
    which_subtest
    more_options
elif [ "$test" == "6" ]; then
    ib_test=ib_read_lat
    which_subtest
    more_options
elif [ "$test" == "7" ]; then
    more_options
    rdma_xserver_rdma_xclient
    exit
elif [ "$test" == "8" ]; then
    more_options
    rdma_server_rdma_client
    exit
else
    echo "ERROR: Invalid Argument"
    exit
fi

if [ "$subtest" == "1" ]; then
        kill_process 
	change_mtu
elif [ "$subtest" == "2" ]; then
        kill_process 
        qp_test
elif [ "$subtest" == "3" ]; then
        kill_process 
        message_size
elif [ "$subtest" == "4" ]; then
        kill_process 
        iteration_test
elif [ "$subtest" == "5" ]; then
        kill_process 
        gid_index
else
    echo "ERROR: Invalid Argument"
    exit
fi
