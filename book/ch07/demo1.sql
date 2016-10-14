drop table a;
drop table b;
set echo on

create table a ( x int );
create table b ( x int );
alter session set isolation_level = serializable;

set echo off
prompt in another session execute:
prompt alter session set isolation_level = serializable;;
pause
set echo on

insert into a select count(*) from b;
set echo off
prompt in another session execute:
prompt insert into b select count(*) from a;;
pause
set echo on

commit;
set echo off
prompt in another session execute:
prompt commit;;
pause
set echo on

commit;
select * from a;
select * from b;
