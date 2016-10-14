set echo on
set linesize 1000
drop table t purge;

create table t
( OWNER, OBJECT_NAME, SUBOBJECT_NAME, OBJECT_ID, DATA_OBJECT_ID,
  OBJECT_TYPE, CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS,
  TEMPORARY, GENERATED, SECONDARY )
/*
partition by hash(object_id)
partitions 16
*/
as
select OWNER, OBJECT_NAME, SUBOBJECT_NAME, OBJECT_ID, DATA_OBJECT_ID,
  OBJECT_TYPE, CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS,
  TEMPORARY, GENERATED, SECONDARY 
 from all_objects;
create index t_idx
on t(owner,object_type,object_name)
/*
LOCAL
*/
/
begin
   dbms_stats.gather_table_stats
   ( user, 'T', method_opt=> 'for all indexed columns' );
end;
/


variable o varchar2(30)
variable t varchar2(30)
variable n varchar2(30)

exec :o := 'SCOTT'; :t := 'TABLE'; :n := 'EMP';
@trace
set autotrace traceonly
select *
  from t
 where owner = :o
   and object_type = :t
   and object_name = :n
/
select *
  from t
 where owner = :o
   and object_type = :t
/
select *
  from t
 where owner = :o
/
set autotrace off
pause
@tk "sys=no"

drop index t_idx;


create index t_idx
on t(owner,object_type,object_name)
global
partition by hash(owner)
partitions 16
/


variable o varchar2(30)
variable t varchar2(30)
variable n varchar2(30)

exec :o := 'SCOTT'; :t := 'TABLE'; :n := 'EMP';
@trace
set autotrace traceonly 
select *
  from t
 where owner = :o
   and object_type = :t
   and object_name = :n
/
select *
  from t
 where owner = :o
   and object_type = :t
/
select *
  from t
 where owner = :o
/
set autotrace off
pause
@tk "sys=no"

