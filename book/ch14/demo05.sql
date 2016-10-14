set echo on
set linesize 1000
drop table t1 purge;
drop table t2 purge;

create table t1
as
select object_id id, object_name text
  from all_objects;
begin
    dbms_stats.set_table_stats
    ( user, 'T1', numrows=>10000000,numblks=>100000 );
end;
/
create table t2
as
select t1.*, 0 session_id
  from t1
 where 1=0;

pause


CREATE OR REPLACE TYPE t2_type
AS OBJECT (
 id         number,
 text       varchar2(30),
 session_id number
)
/
create or replace type t2_tab_type
as table of t2_type
/
pause

create or replace
function parallel_pipelined( l_cursor in sys_refcursor )
return t2_tab_type
pipelined
parallel_enable ( partition l_cursor by any )
is
    l_session_id number;
    l_rec        t1%rowtype;
begin
    select sid into l_session_id
      from v$mystat
     where rownum =1;
    loop
        fetch l_cursor into l_rec;
        exit when l_cursor%notfound;
        -- complex process here
        pipe row(t2_type(l_rec.id,l_rec.text,l_session_id));
    end loop;
    close l_cursor;
    return;
end;
/
pause

alter session enable parallel dml;
insert /*+ append */
into t2(id,text,session_id)
select *
from table(parallel_pipelined
          (CURSOR(select /*+ parallel(t1) */ *
                    from t1 )
           ))
/
commit;
select session_id, count(*)
  from t2
 group by session_id;

