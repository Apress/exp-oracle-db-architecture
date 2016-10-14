drop TABLE partitioned purge;
CREATE TABLE partitioned
( load_date date,
  id        int,
  constraint partitioned_pk primary key(id)
)
PARTITION BY RANGE (load_date)
(
PARTITION part_1 VALUES LESS THAN
( to_date('01/01/2000','dd/mm/yyyy') ) ,
PARTITION part_2 VALUES LESS THAN
( to_date('01/01/2001','dd/mm/yyyy') )
)
/
select segment_name, partition_name, segment_type
  from user_segments;


drop table partitioned purge;


CREATE TABLE partitioned
( timestamp date,
  id        int
)
PARTITION BY RANGE (timestamp)
(
PARTITION part_1 VALUES LESS THAN
( to_date('01-jan-2000','dd-mon-yyyy') ) ,
PARTITION part_2 VALUES LESS THAN
( to_date('01-jan-2001','dd-mon-yyyy') )
)
/
create index partitioned_idx
on partitioned(id) local
/
select segment_name, partition_name, segment_type
  from user_segments;
alter table partitioned
add constraint
partitioned_pk
primary key(id)
/

