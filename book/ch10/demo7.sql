create table iot
( owner, object_type, object_name,
  primary key(owner,object_type,object_name)
)
organization index
NOCOMPRESS
as
select distinct owner, object_type, object_name from all_objects
/

