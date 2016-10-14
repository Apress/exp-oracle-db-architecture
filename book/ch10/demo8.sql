drop table iot;

create table iot
( owner, object_type, object_name,
  constraint iot_pk primary key(owner,object_type,object_name)
)
organization index
NOCOMPRESS
as
select distinct owner, object_type, object_name
  from all_objects
/
analyze index iot_pk validate structure;
select lf_blks, br_blks, used_space,
       opt_cmpr_count, opt_cmpr_pctsave
  from index_stats;
alter table iot move compress 1;
analyze index iot_pk validate structure;
select lf_blks, br_blks, used_space,
       opt_cmpr_count, opt_cmpr_pctsave
  from index_stats;
alter table iot move compress 2;
analyze index iot_pk validate structure;
select lf_blks, br_blks, used_space,
       opt_cmpr_count, opt_cmpr_pctsave
  from index_stats;
 

