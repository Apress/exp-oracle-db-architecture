drop table t purge;
create table t
( x int primary key,
  y date,
  z clob
)
/
select dbms_metadata.get_ddl( 'TABLE', 'T' ) from dual;
 

