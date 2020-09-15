#!/bin/sh

LOWER=5
UPPER=15
#RAND_NUM=$[ ( $RANDOM % ( $[ $UPPER - $LOWER ] + 1 ) ) + $LOWER ]
RAND_NUM=$[ $[ ( $RANDOM % ( $[ $UPPER - $LOWER ] + 1 ) ) + $LOWER ] * 60 ]
echo $RAND_NUM
