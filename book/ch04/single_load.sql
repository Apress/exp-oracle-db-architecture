connect /
set echo on
declare
    l_first_time boolean default true;
begin
    for x in ( select * from t order by 1, 2, 3, 4 )
    loop
        if ( l_first_time )
        then
            insert into sess_stats
            ( name, value, active )
            select name, value, 
                  (select count(*) 
                     from v$session 
                    where status = 'ACTIVE' 
                      and username is not null)
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
            l_first_time := false;
        end if;
    end loop;
end;
/
commit;


