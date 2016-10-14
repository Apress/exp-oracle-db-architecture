select a.username, a.sid, a.serial#, a.server,
       a.paddr, a.status, b.program
  from v$session a left join v$process b
    on (a.paddr = b.addr)
 where a.username = 'OPS$TKYTE'
/
