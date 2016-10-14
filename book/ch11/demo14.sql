create table t ( x char(1) constraint t_pk primary key, 
y date );
insert into t values ( '5', sysdate );
delete from plan_table;
explain plan for select * from t where x = 5;
select * from table(dbms_xplan.display);
explain plan for select /*+ INDEX(t t_pk) */ * from t 
where x = 5;
select * from table(dbms_xplan.display);
delete from plan_table;
explain plan for select * from t where x = '5';
select * from table(dbms_xplan.display);

