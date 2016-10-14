create table t
as
select * from all_objects;
create index t_idx_1 on t(owner,object_type,object_name);
create index t_idx_2 on t(object_name,object_type,owner);
select count(distinct owner), count(distinct object_type),
 count(distinct object_name ), count(*)
from t;
analyze index t_idx_1 validate structure;
select btree_space, pct_used, opt_cmpr_count, opt_cmpr_pctsave
from index_stats;
analyze index t_idx_2 validate structure;
select btree_space, pct_used, opt_cmpr_count, opt_cmpr_pctsave
from index_stats;
alter session set sql_trace=true;
declare
        cnt int;
begin
  for x in ( select /*+FULL(t)*/ owner, object_type, object_name from t )
  loop
       select /*+ INDEX( t t_idx_1 ) */ count(*) into cnt
         from t
        where object_name = x.object_name
          and object_type = x.object_type
          and owner = x.owner;

        select /*+ INDEX( t t_idx_2 ) */ count(*) into cnt
         from t
        where object_name = x.object_name
          and object_type = x.object_type
          and owner = x.owner;
  end loop;
end;
/

