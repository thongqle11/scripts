#!/bin/bash
users=`multipath -ll| wc -l`
echo $users
