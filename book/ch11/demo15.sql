create table t
( x, y , primary key (x) )
as
select rownum x, object_name
  from all_objects
/
begin
   dbms_stats.gather_table_stats
   ( user, 'T', cascade=>true );
end;
/
set autotrace on explain
select count(y) from t where x < 50;
select count(y) from t where x < 15000;

