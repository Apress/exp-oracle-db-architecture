update big_table set temporary = decode(temporary,'N','Y','N');
select temporary, cnt,
       round( (ratio_to_report(cnt) over ()) * 100, 2 ) rtr
  from (
select temporary, count(*) cnt
  from big_table
 group by temporary
       )
/
create index processed_flag_idx
on big_table(temporary);
analyze index processed_flag_idx
validate structure;
select name, btree_space, lf_rows, height
  from index_stats;
drop index processed_flag_idx;
create index processed_flag_idx
on big_table( case temporary when 'N' then 'N' end );
analyze index processed_flag_idx
validate structure;
select name, btree_space, lf_rows, height
  from index_stats;

