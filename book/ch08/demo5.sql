drop table t;

create table t ( x int unique );
insert into t values ( 1 );
insert into t values ( 2 );
commit;

update t set x=x+1;
commit;
update t set x=x-1;
commit;
