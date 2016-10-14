set echo on
set linesize 1000
drop table t2 purge;

create table t2
as
select object_id id, object_name text, 0 session_id
  from big_table
 where 1=0;


create or replace
procedure serial( p_lo_rid in rowid, p_hi_rid in rowid )
is
begin
    for x in ( select object_id id, object_name text
                 from big_table
                where rowid between p_lo_rid
                                and p_hi_rid )
    loop
        -- complex process here
        insert into t2 (id, text, session_id )
        values ( x.id, x.text, sys_context( 'userenv', 'sessionid' ) );
    end loop;
end;
/
begin
    dbms_parallel_execute.create_task('process big table');
    dbms_parallel_execute.create_chunks_by_rowid
    ( task_name   => 'process big table',
      table_owner => user,
      table_name  => 'BIG_TABLE',
      by_row      => false,
      chunk_size  => 10000 );
end;
/

select * 
  from (
select chunk_id, status, start_rowid, end_rowid
  from dba_parallel_execute_chunks
 where task_name = 'process big table'
 order by chunk_id
       )
 where rownum <= 5
/


begin
    dbms_parallel_execute.run_task
    ( task_name      => 'process big table',
      sql_stmt       => 'begin serial( :start_id, :end_id ); end;',
      language_flag  => DBMS_SQL.NATIVE,
      parallel_level => 4 );
end;
/

select * 
  from (
select chunk_id, status, start_rowid, end_rowid
  from dba_parallel_execute_chunks
 where task_name = 'process big table'
 order by chunk_id
       )
 where rownum <= 5
/


begin
      dbms_parallel_execute.drop_task('process big table' );
end;
/

select session_id, count(*)
  from t2
 group by session_id 
 order by session_id;


