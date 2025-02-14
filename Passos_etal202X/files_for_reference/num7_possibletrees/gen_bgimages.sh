#!/bin/bash

NUM_FILES=$( ls -l | grep -i '.tex' | wc -l )

k=1
while [ $k -le $NUM_FILES ]
do
	eval "convert num7variant${k}.png -background white -flatten num7variant${k}.png"
	k=`expr $k + 1`
done
