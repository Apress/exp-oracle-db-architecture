connect /
set echo on

drop table t;


create undo tablespace undo_small
datafile '/tmp/undo.dbf' size 2m
autoextend off
/
alter system set undo_tablespace = undo_small;
create table t
as
select *
  from all_objects
 order by dbms_random.random;
alter table t add constraint t_pk primary key(object_id)
/
exec dbms_stats.gather_table_stats( user, 'T', cascade=> true );

set echo off
prompt, in another session, start this running:
prompt begin
prompt     for x in ( select rowid rid from t )
prompt     loop
prompt         update t set object_name = lower(object_name) where rowid = x.rid;;
prompt         commit;;
prompt     end loop;;
prompt end;;
prompt /
pause
set echo on

declare
    cursor c is
    select /*+ first_rows */ object_name
      from t
     order by object_id;

    l_object_name t.object_name%type;
    l_rowcnt      number := 0;
begin
    open c;
    loop
        fetch c into l_object_name;
        exit when c%notfound;
        dbms_lock.sleep( 0.01 );
        l_rowcnt := l_rowcnt+1;
    end loop;
    close c;
exception
    when others then
        dbms_output.put_line( 'rows fetched = ' || l_rowcnt );
        raise;
end;
/
pause

alter database 
datafile '/tmp/undo.dbf'
autoextend on
next 1m
maxsize 2048m;

set echo off
prompt, in another session, start this running:
prompt begin
prompt     for x in ( select rowid rid from t )
prompt     loop
prompt         update t set object_name = lower(object_name) where rowid = x.rid;;
prompt         commit;;
prompt     end loop;;
prompt end;;
prompt /
pause
set echo on
declare
    cursor c is
    select /*+ first_rows */ object_name
      from t
     order by object_id;

    l_object_name t.object_name%type;
    l_rowcnt      number := 0;
begin
    open c;
    loop
        fetch c into l_object_name;
        exit when c%notfound;
        dbms_lock.sleep( 0.01 );
        l_rowcnt := l_rowcnt+1;
    end loop;
    close c;
exception
    when others then
        dbms_output.put_line( 'rows fetched = ' || l_rowcnt );
        raise;
end;
/
select bytes/1024/1024
  from dba_data_files
where tablespace_name = 'UNDO_SMALL';

alter system set undo_tablespace = UNDOTBS1;
disconnect
connect /
drop tablespace undo_small including contents and datafiles;
