regex='[0-9]\{1,3\}:[0-9]\{1,3\}'
for i in `cat input | grep -o $regex`;do
        if [ $? = 0 ]; then
                echo "Output is $?"
                device=$(cat mpath.tmp | grep -w $i | awk '{print $3}')
                lsscsi_output=$(cat lsscsi.tmp | grep -w $device)
                echo $i ">" $device ">" $lsscsi_output
        else [ $? = 1 ]
                echo "No match in multipath -ll output."
                echo "Output is $?"
        fi
done
