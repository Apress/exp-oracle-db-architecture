create table t
as
select decode(mod(rownum,2), 0, 'M', 'F' ) gender, all_objects.*
  from all_objects
/
create index t_idx on t(gender,object_id)
/
begin
        dbms_stats.gather_table_stats
        ( user, 'T', cascade=>true );
end;
/
set autotrace traceonly explain
select * from t t1 where object_id = 42;
update t
   set gender = chr(mod(rownum,256));
begin
        dbms_stats.gather_table_stats
        ( user, 'T', cascade=>true );
end;
/
set autotrace traceonly explain
select * from t t1 where object_id = 42;

