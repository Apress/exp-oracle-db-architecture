set echo on

connect /
select (select username
          from v$session
         where sid = v$lock.sid) username,
       sid,
       id1,
       id2,
       lmode,
       request, block, v$lock.type
  from v$lock
 where id1 = 228611
/
