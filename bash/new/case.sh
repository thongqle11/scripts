#!/bin/bash
read var
case "$var" in
	a) var=a; echo "Variable is $var";;
	b) var=b; echo "Variable is $var";;
esac

