#!/bin/bash

for i in `seq 1 $*`
do
	./ch11 &
done
wait
