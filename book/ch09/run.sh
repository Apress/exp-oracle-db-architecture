#!/bin/bash

$ORACLE_HOME/bin/sqlplus / @test2 1 &
$ORACLE_HOME/bin/sqlplus / @test2 2 &
$ORACLE_HOME/bin/sqlplus / @test2 3 &
$ORACLE_HOME/bin/sqlplus / @test2 4 &
$ORACLE_HOME/bin/sqlplus / @test2 5 &
$ORACLE_HOME/bin/sqlplus / @test2 6 &
$ORACLE_HOME/bin/sqlplus / @test2 7 &
$ORACLE_HOME/bin/sqlplus / @test2 8 &
$ORACLE_HOME/bin/sqlplus / @test2 9 &
wait
