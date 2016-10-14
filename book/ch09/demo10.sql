set echo on
drop table t;

create table t
as
select object_name unindexed,
       object_name indexed
  from all_objects
/
create index t_idx on t(indexed);
exec dbms_stats.gather_table_stats(user,'T');
select used_ublk
  from v$transaction
 where addr = (select taddr
                 from v$session
                where sid = (select sid
                               from v$mystat
                              where rownum = 1
                            )
              )
/
update t set unindexed = lower(unindexed);
select used_ublk
  from v$transaction
 where addr = (select taddr
                 from v$session
                where sid = (select sid
                               from v$mystat
                              where rownum = 1
                            )
              )
/
commit;
update t set indexed = lower(indexed);
select used_ublk
  from v$transaction
 where addr = (select taddr
                 from v$session
                where sid = (select sid
                               from v$mystat
                              where rownum = 1
                            )
              )
/
