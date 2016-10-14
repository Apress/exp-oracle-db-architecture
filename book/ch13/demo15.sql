drop table t purge;

create table t
as
select *
  from all_users
/
create index t_idx
on t(user_id)
global
partition by hash(user_id)
partitions 4
/
set autotrace on explain
select /*+ index( t t_idx ) */ user_id
  from t
 where user_id > 0
/
set autotrace off

