drop table t purge;

select segment_name, segment_type
  from user_segments;

Create table t 
( x int primary key, 
  y clob, 
  z blob )
SEGMENT CREATION IMMEDIATE
/

select segment_name, segment_type
  from user_segments;

