#!/bin/bash

NUM_FILES=$( ls -l | grep -i '.tex' | wc -l )

k=1
while [ $k -le $NUM_FILES ]
do
	eval "convert est_variant${k}.png -background white -flatten est_variant${k}.png"
	k=`expr $k + 1`
done
