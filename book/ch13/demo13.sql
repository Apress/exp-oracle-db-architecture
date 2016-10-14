drop table emp;

create table emp
(EMPNO             NUMBER(4) NOT NULL,
 ENAME             VARCHAR2(10),
 JOB               VARCHAR2(9),
 MGR               NUMBER(4),
 HIREDATE          DATE,
 SAL               NUMBER(7,2),
 COMM              NUMBER(7,2),
 DEPTNO            NUMBER(2) NOT NULL,
 LOC               VARCHAR2(13) NOT NULL
)
partition by range(loc)
(
partition p1 values less than('C') tablespace p1,
partition p2 values less than('D') tablespace p2,
partition p3 values less than('N') tablespace p3,
partition p4 values less than('Z') tablespace p4
)
/
alter table emp add constraint emp_pk
primary key(empno)
/
create index emp_job_idx on emp(job)
GLOBAL
/
create index emp_dept_idx on emp(deptno)
GLOBAL
/
insert into emp
select e.*, d.loc
  from scott.emp e, scott.dept d
 where e.deptno = d.deptno
/
break on pname skip 1
select 'p1' pname, empno, job, loc from emp partition(p1)
union all
select 'p2' pname, empno, job, loc from emp partition(p2)
union all
select 'p3' pname, empno, job, loc from emp partition(p3)
union all
select 'p4' pname, empno, job, loc from emp partition(p4)
/
variable x varchar2(30);
begin
   dbms_stats.set_table_stats
   ( user, 'EMP', numrows=>100000, numblks => 10000 );
end;
/
delete from plan_table;
explain plan for
select empno, job, loc from emp where empno = :x;
select * from table(dbms_xplan.display);
delete from plan_table;
explain plan for
select empno, job, loc from emp where job = :x;
select * from table(dbms_xplan.display);
alter tablespace p1 offline;
alter tablespace p2 offline;
alter tablespace p3 offline;
select empno, job, loc from emp where empno = 7782;
select empno, job, loc from emp where job = 'CLERK';
select count(*) from emp where job = 'CLERK';
 

