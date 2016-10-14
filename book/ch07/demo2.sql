drop table t;

set echo on
create table t ( x int );
insert into t values ( 1 );
exec dbms_stats.gather_table_stats( user, 'T' );
select * from t;
alter session set isolation_level=serializable;
set autotrace on statistics
select * from t;

set echo off
prompt in another session:
prompt begin
prompt     for i in 1 .. 10000
prompt     loop
prompt         update t set x = x+1;;
prompt         commit;;
prompt     end loop;;
prompt end;;
prompt /
pause
set echo on

select * from t;
set autotrace off
