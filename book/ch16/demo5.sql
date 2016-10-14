
connect /

set echo on


drop table t;
create table t
( last_name varchar2(30),
  encrypted_name varchar2(30) ENCRYPT
);

insert into t(last_name)
select object_name from stage;
exec show_space( 'T' )
truncate table t;
insert into t(encrypted_name)
select object_name from stage;
exec show_space( 'T' )

truncate table t;
alter table t modify encrypted_name encrypt NO SALT;

insert into t(encrypted_name)
select object_name from stage;
exec show_space( 'T' )

