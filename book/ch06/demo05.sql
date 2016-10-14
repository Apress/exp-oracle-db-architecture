set echo on
drop table c;
drop table p;

create table p ( x int primary key );
create table c ( x references p );

insert into p values ( 1 );
insert into p values ( 2 );
commit;
insert into c values ( 2 );

set echo off

prompt in another session issue:
prompt delete from p where x = 1;;
