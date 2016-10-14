compute sum of bytes on pool
break on pool skip 1

select pool, name, bytes
  from v$sgastat
 order by pool, name;

