set echo on

create table t1
(  x int primary key,
   y varchar2(25),
   z date
)
organization index;
create table t2
(  x int primary key,
   y varchar2(25),
   z date
)
organization index
OVERFLOW;
create table t3
(  x int primary key,
   y varchar2(25),
   z date
)
organization index
overflow INCLUDING y;
select dbms_metadata.get_ddl( 'TABLE', 'T1' ) from dual;
 

