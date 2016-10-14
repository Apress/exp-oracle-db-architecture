connect /
drop table encrypted;
drop table nonencrypted;
drop table stage;
drop tablespace encrypted including contents and datafiles;
drop tablespace clear including contents and datafiles;
set echo on
set linesize 1000

create tablespace encrypted
datafile '/tmp/encrypted.dbf' size 1m
autoextend on next 1m
ENCRYPTION 
default storage ( ENCRYPT );

create tablespace clear
datafile '/tmp/clear.dbf' size 1m
autoextend on next 1m;

create table stage
as
select * 
  from all_objects
/

create table nonencrypted
tablespace clear
as
select *
  from stage
 where 1=0
/
alter table nonencrypted 
add constraint nonencrypted_pk
primary key(object_id)
using index 
(create index nonencrypted_pk 
 on nonencrypted(object_id) 
 tablespace clear );

create table encrypted
tablespace encrypted
as
select *
  from stage
 where 1=0
/
alter table encrypted 
add constraint encrypted_pk
primary key(object_id)
using index 
(create index encrypted_pk 
 on encrypted(object_id) 
 tablespace encrypted );

create or replace 
procedure do_sql( p_sql in varchar2, 
                  p_tname in varchar2,
                  p_truncate in boolean default true )
authid current_user
as
    l_start_cpu number;
    l_start_redo number;
    l_total_redo number;
begin
    if (p_truncate)
    then
        execute immediate 'truncate table ' || p_tname;
    end if;

    dbms_output.put_line( replace( p_sql, '#TNAME#', p_tname ) );

    l_start_cpu := dbms_utility.get_cpu_time;
    l_start_redo := get_stat_val( 'redo size' );

    execute immediate replace(p_sql,'#TNAME#', p_tname);    
    commit work write batch wait;

    dbms_output.put_line
    ( (dbms_utility.get_cpu_time-l_start_cpu) || ' cpu hsecs' );

    l_total_redo := 
      round((get_stat_val('redo size')-l_start_redo)/1024/1024,1);
    dbms_output.put_line
    ( to_char(l_total_redo,'999,999,999.9') || ' mbytes redo' );
end;
/
show errors 
pause

begin
	do_sql( 'insert into #TNAME# select * from stage', 'nonencrypted' );
	do_sql( 'insert into #TNAME# select * from stage', 'encrypted' );
end;
/
begin
	do_sql( 'insert /*+ APPEND */ into #TNAME# select * from stage', 'nonencrypted' );
	do_sql( 'insert /*+ APPEND */ into #TNAME# select * from stage', 'encrypted' );
end;
/

declare
	l_sql long :=
    'begin ' || 
    	'for x in (select * from stage) ' || 
    	'loop ' || 
    		'insert into #TNAME# values X; ' || 
    	'end loop; ' || 
    'end; ';
begin
	do_sql( l_sql, 'nonencrypted' );
	do_sql( l_sql, 'encrypted' );
end;
/

declare
	l_sql long := 
    'begin ' || 
        'for x in (select object_id from stage) ' || 
	    'loop ' || 
    		'for y in (select * from #TNAME# where object_id = x.object_id) ' || 
    		'loop ' || 
    			'null; ' || 
    		'end loop; ' || 
    	'end loop; ' || 
    'end; ';
begin
	do_sql( l_sql, 'nonencrypted', FALSE );
	do_sql( l_sql, 'encrypted', FALSE );
end;
/
alter system flush buffer_cache;

declare
	l_sql long := 
    'begin ' || 
        'for x in (select object_id from stage) ' || 
	    'loop ' || 
    		'for y in (select * from #TNAME# where object_id = x.object_id) ' || 
    		'loop ' || 
    			'null; ' || 
    		'end loop; ' || 
    	'end loop; ' || 
    'end; ';
begin
	do_sql( l_sql, 'nonencrypted', FALSE );
	do_sql( l_sql, 'encrypted', FALSE );
end;
/

exec dbms_stats.gather_table_stats( user, 'NONENCRYPTED' );
exec dbms_stats.gather_table_stats( user, 'ENCRYPTED' );
set autotrace traceonly explain
select * from nonencrypted where object_name = 'ALL_OBJECTS';
select * from encrypted where object_name = 'ALL_OBJECTS';
set autotrace off
