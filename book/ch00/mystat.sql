set echo off
set verify off
column value new_val V
define S="&1"
column name format a45

set autotrace off
select a.name, b.value 
from v$statname a, v$mystat b
where a.statistic# = b.statistic#
and lower(a.name) like '%' || lower('&S')||'%'
-- and lower(a.name) = lower('&S')
/
set echo on
