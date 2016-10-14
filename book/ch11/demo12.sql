create table t ( x int, y int );
create unique index t_idx on t(x,y);
insert into t values ( 1, 1 );
insert into t values ( 1, NULL );
insert into t values ( NULL, 1 );
insert into t values ( NULL, NULL );
analyze index t_idx validate structure;
select name, lf_rows from index_stats;
insert into t values ( NULL, NULL );
insert into t values ( NULL, 1 );
insert into t values ( 1, NULL );
select x, y, count(*)
from t
group by x,y
having count(*) > 1;

drop table t;
create table t ( x int, y int NOT NULL );
create unique index t_idx on t(x,y);
insert into t values ( 1, 1 );
insert into t values ( NULL, 1 );
begin
  dbms_stats.gather_table_stats(user,'T');
end;
/
set autotrace on
select * from t where x is null;
set autotrace off
