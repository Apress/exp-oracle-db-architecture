select nt, min(id), max(id), count(*)
  from (
select id, ntile(10) over (order by id) nt
  from big_table
       )
 group by nt;

