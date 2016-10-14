drop table sess_stats;
create table sess_stats
as
select name, value, 0 active
  from 
(
select a.name, b.value
  from v$statname a, v$sesstat b
 where a.statistic# = b.statistic#
   and b.sid = (select sid from v$mystat where rownum=1)
   and (a.name like '%ga %'
        or a.name like '%direct temp%')
 union all
select 'total: ' || a.name, sum(b.value)
  from v$statname a, v$sesstat b, v$session c
 where a.statistic# = b.statistic#
   and (a.name like '%ga %'
        or a.name like '%direct temp%')
   and b.sid = c.sid
   and c.username is not null
 group by 'total: ' || a.name
); 
