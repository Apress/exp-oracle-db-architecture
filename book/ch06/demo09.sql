set echo on

drop table t1;
drop table t2;
column username format a9

create table t1 ( x int );
create table t2 ( x int );

connect /
insert into t1 values ( 1 );
insert into t2 values ( 1 );
select (select username
          from v$session
         where sid = v$lock.sid) username,
       sid,
       id1,
       id2,
       lmode,
       request, block, v$lock.type
  from v$lock
 where sid = (select sid
                from v$mystat
               where rownum=1)
/
select object_name, object_id
  from user_objects
 where object_name in ('T1','T2')
/
