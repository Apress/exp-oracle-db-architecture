drop table t;
drop table idx_stats;
set echo on


create table t
as
select * from all_objects
 where rownum <= 50000;
create index t_idx on
t(owner,object_type,object_name);
analyze index t_idx validate structure;
create table idx_stats
as
select 'noncompressed' what, a.*
  from index_stats a;

@test2 1
@test2 2
@test2 3

select what, height, lf_blks, br_blks,
       btree_space, opt_cmpr_count, opt_cmpr_pctsave
  from idx_stats
/
