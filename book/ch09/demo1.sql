set echo on

drop table t purge;
alter session set deferred_segment_creation = false;
create table t
as
select *
  from all_objects
 where 1=0;
select * from t;
set autotrace traceonly statistics
select * from t;
set autotrace off

insert into t select * from all_objects;
rollback;
select * from t;
set autotrace traceonly statistics
select * from t;
set autotrace off
