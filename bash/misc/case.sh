#!/bin/bash


echo "Use multipath -ll output or use from file?"
echo "1)Use multipath -ll"
echo "2)From file"

read answer
case $answer in
        "1") echo "Use multipath -ll output.";;
	"2") echo "Use file";;
esac


