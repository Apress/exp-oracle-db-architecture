merge into sess_stats
using
(
select a.name, b.value
  from v$statname a, v$sesstat b
 where a.statistic# = b.statistic#
   and b.sid = :sid
   and (a.name like '%ga %'
        or a.name like '%direct temp%')
) curr_stats
on (sess_stats.name = curr_stats.name)
when matched then
  update set diff = curr_stats.value - sess_stats.value,
             value = curr_stats.value
when not matched then
  insert ( name, value, diff )
  values
  ( curr_stats.name, curr_stats.value, null )
/

select name, 
       case when name like '%ga %' 
            then round(value/1024,0) 
            else value 
        end kbytes_writes, 
       case when name like '%ga %' 
            then round(diff /1024,0) 
            else value 
        end diff_kbytes_writes
  from sess_stats
 order by name; 

