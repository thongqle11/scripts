#!/bin/bash

echo "Enter input: "
read INPUT
if [ $INPUT == 1 ]; then
	echo "You typed 1"
elif [ $INPUT == 2 ]; then
	echo "You type 2"
else
	echo "You didn't type 1."
fi
