set echo on
set linesize 1000
commit;
alter session enable parallel dml;
update big_table set status = 'done';
select a.sid, a.program, b.start_time, b.used_ublk,
       b.xidusn ||'.'|| b.xidslot || '.' || b.xidsqn trans_id
  from v$session a, v$transaction b
 where a.taddr = b.addr
   and a.sid in ( select sid
                    from v$px_session
                   where qcsid = (select sid
                                    from v$mystat
                                   where rownum=1)
 order by sid
/

