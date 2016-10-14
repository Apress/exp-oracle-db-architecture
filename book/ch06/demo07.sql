column username format a9
drop table emp;
drop table dept;
set echo on


create table dept 
as select * from scott.dept;
create table emp
as select * from scott.emp;
alter table dept 
add constraint dept_pk 
primary key(deptno);

alter table emp
add constraint emp_pk
primary key(empno);

alter table emp 
add constraint emp_fk_dept
foreign key (deptno) 
references dept(deptno);

create index emp_deptno_idx
on emp(deptno);


update dept
   set dname = initcap(dname);


select username,
       v$lock.sid,
       trunc(id1/power(2,16)) rbs,
       bitand(id1,to_number('ffff','xxxx'))+0 slot,
       id2 seq,
       lmode,
       request
from v$lock, v$session
where v$lock.type = 'TX'
  and v$lock.sid = v$session.sid
  and v$session.username = USER;

select XIDUSN, XIDSLOT, XIDSQN
  from v$transaction;

set echo off
prompt in another session
prompt update emp set ename = upper(ename);;
prompt update dept set deptno = deptno-10;;
set echo on
pause


select username,
       v$lock.sid,
       trunc(id1/power(2,16)) rbs,
       bitand(id1,to_number('ffff','xxxx'))+0 slot,
       id2 seq,
       lmode,
       request
from v$lock, v$session
where v$lock.type = 'TX'
  and v$lock.sid = v$session.sid
  and v$session.username = USER;

select XIDUSN, XIDSLOT, XIDSQN
  from v$transaction;

pause

select
      (select username from v$session where sid=a.sid) blocker,
       a.sid,
      ' is blocking ',
       (select username from v$session where sid=b.sid) blockee,
           b.sid
  from v$lock a, v$lock b
 where a.block = 1
   and b.request > 0
   and a.id1 = b.id1
   and a.id2 = b.id2;

pause

commit;

pause


select username,
       v$lock.sid,
       trunc(id1/power(2,16)) rbs,
       bitand(id1,to_number('ffff','xxxx'))+0 slot,
       id2 seq,
       lmode,
       request
from v$lock, v$session
where v$lock.type = 'TX'
  and v$lock.sid = v$session.sid
  and v$session.username = USER;

select XIDUSN, XIDSLOT, XIDSQN
  from v$transaction;

