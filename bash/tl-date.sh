#!/bin/bash
start_time_in_sec=$(date --date="$1" +%s)
echo "The script will add $2 seconds to $1"
new_time_in_sec=$(($start_time_in_sec + $2))
new_date=$(date --date="1970-01-01 $new_time_in_sec sec GMT")
echo "The new date is $new_date"
