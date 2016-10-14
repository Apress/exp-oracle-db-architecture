set echo on
drop table t;

create table t 
( x int constraint x_not_null not null deferrable, 
  y int constraint y_not_null not null, 
  z varchar2(30) 
); 
insert into t(x,y,z) 
select rownum, rownum, rpad('x',30,'x') 
  from all_users; 
exec dbms_stats.gather_table_stats( user, 'T' ); 
create index t_idx on t(y); 
set autotrace traceonly explain 
select count(*) from t; 
set autotrace off
drop index t_idx; 
create index t_idx on t(x); 
set autotrace traceonly explain 
select count(*) from t; 
set autotrace off
alter table t drop constraint x_not_null; 
alter table t modify x constraint x_not_null not null; 
set autotrace traceonly explain 
select count(*) from t; 
set autotrace off
