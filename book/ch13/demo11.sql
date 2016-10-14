set echo on
set linesize 1000
drop TABLE partitioned purge;
CREATE TABLE partitioned
( timestamp date,
  id        int
)
PARTITION BY RANGE (timestamp)
(
PARTITION fy_2004 VALUES LESS THAN
( to_date('01-jan-2005','dd-mon-yyyy') ) ,
PARTITION fy_2005 VALUES LESS THAN
( to_date('01-jan-2006','dd-mon-yyyy') )
)
/
insert into partitioned partition(fy_2004)
select to_date('31-dec-2004','dd-mon-yyyy')-mod(rownum,360), object_id
from all_objects
/
insert into partitioned partition(fy_2005)
select to_date('31-dec-2005','dd-mon-yyyy')-mod(rownum,360), object_id
from all_objects
/
create index partitioned_idx_local
on partitioned(id)
LOCAL
/
create index partitioned_idx_global
on partitioned(timestamp)
GLOBAL
/
create table fy_2004 ( timestamp date, id int );
create index fy_2004_idx on fy_2004(id)
/
create table fy_2006 ( timestamp date, id int );
insert into fy_2006
select to_date('31-dec-2006','dd-mon-yyyy')-mod(rownum,360), object_id
from all_objects
/
create index fy_2006_idx on fy_2006(id) nologging
/
alter table partitioned
exchange partition fy_2004
with table fy_2004
including indexes
without validation
/
alter table partitioned
drop partition fy_2004
/
alter table partitioned
add partition fy_2006
values less than ( to_date('01-jan-2007','dd-mon-yyyy') )
/
alter table partitioned
exchange partition fy_2006
with table fy_2006
including indexes
without validation
/
select index_name, status from user_indexes;
set autotrace on explain
select /*+ index( partitioned PARTITIONED_IDX_GLOBAL ) */ count(*)
from partitioned
where timestamp between to_date( '01-mar-2006', 'dd-mon-yyyy' ) 
  and to_date( '31-mar-2006', 'dd-mon-yyyy' );
select count(*)
from partitioned
where timestamp between to_date( '01-mar-2006', 'dd-mon-yyyy' ) 
  and to_date( '31-mar-2006', 'dd-mon-yyyy' );
set autotrace off

