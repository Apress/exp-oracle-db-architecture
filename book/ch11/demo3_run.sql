set echo on

define NumUsers=&1
define Which=&2

@demo3_creates &3

exec statspack.snap
!./demo3_&Which..sh &NumUsers
exec statspack.snap

column b new_val begin_snap
column e new_val end_snap
define report_name=multiuser_&NumUsers._&Which._&3
select max(decode(rn,1,snap_id)) e, 
       max(decode(rn,2,snap_id)) b
  from (
select snap_id, row_number() over (order by snap_id desc) rn
  from perfstat.stats$snapshot
       )
 where rn <= 2
/

insert into perfstat.STATS$IDLE_EVENT ( event ) 
select 'PL/SQL lock timer' 
  from dual 
 where not exists 
 (select null from perfstat.STATS$IDLE_EVENT where event = 'PL/SQL lock timer')
/
commit;

@?/rdbms/admin/spreport
