set echo on

select a.spid dedicated_server,
           b.process clientpid
  from v$process a, v$session b
 where a.addr = b.paddr
   and b.sid = (select sid from v$mystat where rownum=1)
/

