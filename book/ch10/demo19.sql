drop table dept_and_emp;
drop type emp_tab_type;
drop type emp_type;

create or replace type emp_type
as object
(empno       number(4),
 ename       varchar2(10),
 job         varchar2(9),
 mgr         number(4),
 hiredate    date,
 sal         number(7, 2),
 comm        number(7, 2)
);
/
create or replace type emp_tab_type
as table of emp_type
/
create table dept_and_emp
(deptno number(2) primary key,
 dname     varchar2(14),
 loc       varchar2(13),
 emps      emp_tab_type
)
nested table emps store as emps_nt;
alter table emps_nt add constraint
emps_empno_unique unique(empno)
/

alter table emps_nt add constraint mgr_fk
foreign key(mgr) references emps_nt(empno);

insert into dept_and_emp
select dept.*,
   CAST( multiset( select empno, ename, job, mgr, hiredate, sal, comm
                     from SCOTT.EMP
                     where emp.deptno = dept.deptno ) AS emp_tab_type )
  from SCOTT.DEPT
/

select deptno, dname, loc, d.emps AS employees
from dept_and_emp d
where deptno = 10
/
select d.deptno, d.dname, emp.*
from dept_and_emp D, table(d.emps) emp
/


update
  table( select emps
           from dept_and_emp
                  where deptno = 10
           )
set comm = 100
/
update
  table( select emps
           from dept_and_emp
             where deptno = 1
      )
set comm = 100
/
update
  table( select emps
           from dept_and_emp
             where deptno > 1
      )
set comm = 100
/


insert into table
( select emps from dept_and_emp where deptno = 10 )
values
( 1234, 'NewEmp', 'CLERK', 7782, sysdate, 1200, null );
delete from table
( select emps from dept_and_emp where deptno = 20 )
where ename = 'SCOTT';
select d.dname, e.empno, ename
from dept_and_emp d, table(d.emps) e
where d.deptno in ( 10, 20 );

