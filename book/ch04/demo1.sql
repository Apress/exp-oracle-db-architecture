drop table t;
create table t as select * from all_objects;
exec dbms_stats.gather_table_stats( user, 'T' );

@run_query 65536
@run_query 1048576
@run_query 1073741820
