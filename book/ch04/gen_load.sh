#!/bin/bash
for i in {1..25}
do
	sqlplus / @gen_load.sql &
done
