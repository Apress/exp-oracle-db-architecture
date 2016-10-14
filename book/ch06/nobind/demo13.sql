set echo on
define NumUsers=&1


connect scott/tiger

begin
    for i in 1 .. 10
    loop
        for x in (select * from user_tables where table_name = 'T'||i )
        loop
            execute immediate 'drop table ' || x.table_name;
        end loop;
        execute immediate 'create table t' || i || ' ( x int )';
    end loop;
end;
/


connect /
set echo off
set verify off
set feedback off
spool temp.sh
begin
	dbms_output.put_line( 'echo exec statspack.snap | sqlplus /' );
	for i in 1 .. &NumUsers
	loop
		dbms_output.put_line( 'java instest t' || i ||' ' || chr(38) );
	end loop;
	dbms_output.put_line( 'wait' );
	dbms_output.put_line( 'echo exec statspack.snap | sqlplus /' );
end;
/
spool off
set echo on
set verify on
set feedback on
host /bin/bash temp.sh

column b new_val begin_snap
column e new_val end_snap
define report_name=multiuser_&NumUsers.
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
