@recreateme

create table emp as select * from scott.emp;
create global temporary table gtt1 ( x number )
on commit preserve rows;
create global temporary table gtt2 ( x number )
on commit delete rows;
insert into gtt1 select user_id from all_users;
insert into gtt2 select user_id from all_users;
exec dbms_stats.gather_schema_stats( user );
select table_name, last_analyzed, num_rows from user_tables;
exec dbms_stats.gather_schema_stats( user, gather_temp=>true );
select table_name, last_analyzed, num_rows from user_tables;

