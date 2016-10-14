set echo on
drop table t purge;

create table t ( x int, y char(50) ) 
-- storage( freelists 5 )
-- tablespace mssm;
tablespace assm;

set ech off
!echo begin for i in 1 .. 100000 loop insert into t values \(i,\'x\'\)\; end loop\; commit\; end\; > test.sql
!echo / >> test.sql
!echo exit >> test.sql

!echo \#\!/bin/bash > test.sh
!echo sqlplus / @test.sql \&>> test.sh
!echo sqlplus / @test.sql \&>> test.sh
!echo sqlplus / @test.sql \&>> test.sh
!echo sqlplus / @test.sql \&>> test.sh
!echo sqlplus / @test.sql \&>> test.sh
!echo wait >> test.sh
set echo on

exec statspack.snap
!/bin/bash ./test.sh
exec statspack.snap
@?/rdbms/admin/spreport
