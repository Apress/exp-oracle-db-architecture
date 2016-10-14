drop table emp;
drop table dept;

drop cluster emp_dept_cluster;

create cluster emp_dept_cluster
( deptno number(2) )
size 1024
/

create index emp_dept_cluster_idx
on cluster emp_dept_cluster
/
create table dept
( deptno number(2) primary key,
  dname  varchar2(14),
  loc    varchar2(13)
)
cluster emp_dept_cluster(deptno)
/
create table emp
( empno    number primary key,
  ename    varchar2(10),
  job      varchar2(9),
  mgr      number,
  hiredate date,
  sal      number,
  comm     number,
  deptno number(2) references dept(deptno)
)
cluster emp_dept_cluster(deptno)
/

insert into dept
( deptno, dname, loc )
select deptno+r, dname, loc
  from scott.dept,
      (select level r from dual connect by level < 10);
insert into emp
(empno, ename, job, mgr, hiredate, sal, comm, deptno)
select rownum, ename, job, mgr, hiredate, sal, comm, deptno+r 
  from scott.emp,
      (select level r from dual connect by level < 10);

select min(count(*)), max(count(*)), avg(count(*))
  from dept
 group by dbms_rowid.rowid_block_number(rowid)
/

select *
  from (
select dept_blk, emp_blk,
       case when dept_blk <> emp_blk then '*' end flag,
           deptno
  from (
select dbms_rowid.rowid_block_number(dept.rowid) dept_blk,
       dbms_rowid.rowid_block_number(emp.rowid) emp_blk,
       dept.deptno
  from emp, dept
 where emp.deptno = dept.deptno
       )
	   )
 where flag = '*'
 order by deptno
/
