column username format a9
column sid format 999
column serial# format 99999
column program a36
set linesize 1000
set echo on

select a.username, a.sid, a.serial#, a.server,
       a.paddr, a.status, b.program
  from v$session a left join v$process b
    on (a.paddr = b.addr)
 where a.username = 'OPS$TKYTE'
/
