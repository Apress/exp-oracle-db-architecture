column owner format a9

connect /
set linesize 1000
select session_id sid, owner, name, type, 
       mode_held held, mode_requested request
  from dba_ddl_locks
 where session_id = (select sid from v$mystat where rownum=1)
/

create or replace procedure p
as
begin
 null;
end;
/
exec p

select session_id sid, owner, name, type, 
       mode_held held, mode_requested request
  from dba_ddl_locks
 where session_id = (select sid from v$mystat where rownum=1)
/
alter procedure p compile;
select session_id sid, owner, name, type, 
       mode_held held, mode_requested request
  from dba_ddl_locks
 where session_id = (select sid from v$mystat where rownum=1)
/
