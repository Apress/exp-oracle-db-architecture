connect /
set echo on

/* 
drop table stage;
*/
drop table t;
/*
create table stage 
as 
select object_name 
  from all_objects;
*/

create table t
( non_encrypted varchar2(30),
  encrypted varchar2(30) ENCRYPT
);
/*
create or replace 
procedure do_sql( p_sql in varchar2, 
                  p_truncate in boolean default true )
authid current_user
as
    l_start_cpu number;
    l_start_redo number;
    l_total_redo number;
begin
    if (p_truncate)
    then
        execute immediate 'truncate table t';
    end if;

    dbms_output.put_line( p_sql );

    l_start_cpu := dbms_utility.get_cpu_time;
    l_start_redo := get_stat_val( 'redo size' );

    execute immediate p_sql;    
    commit work write batch wait;

    dbms_output.put_line
    ( (dbms_utility.get_cpu_time-l_start_cpu) || ' cpu hsecs' );

    l_total_redo := 
      round((get_stat_val('redo size')-l_start_redo)/1024/1024,1);
    dbms_output.put_line
    ( to_char(l_total_redo,'999,999,999.9') || ' mbytes redo' );
end;
/

begin
    do_sql( 'insert into t(non_encrypted) ' ||
            'select object_name from stage' );
    do_sql( 'insert into t(encrypted) ' ||
            'select object_name from stage' );
end;
/

declare
    l_sql long := 
    'begin ' || 
       'for x in (select object_name from stage) ' || 
       'loop ' || 
          'insert into t(#CNAME#) ' || 
          'values (x.object_name); ' || 
        'end loop; ' || 
    'end; ';
begin
    do_sql( replace(l_sql,'#CNAME#','non_encrypted') );
    do_sql( replace(l_sql,'#CNAME#','encrypted') );
end;
/
*/


truncate table t;
insert into t select object_name, object_name from stage;
exec dbms_stats.gather_table_stats( user, 'T' );

declare
    l_sql long := 
    'begin ' ||
        'for x in (select #CNAME# from t) ' ||
        'loop ' ||
            'null; ' ||
        'end loop; ' ||
    'end; ';
begin
    do_sql( replace(l_sql,'#CNAME#','non_encrypted'), FALSE );
    do_sql( replace(l_sql,'#CNAME#','encrypted'), FALSE );
end;
/


column PLAN_TABLE_OUTPUT format a100 truncate
set autotrace traceonly explain
select * from t where non_encrypted = 'ALL_OBJECTS';
select * from t where encrypted = 'ALL_OBJECTS';
set autotrace off


