drop table dept;
drop table emp;

create table emp as select * from scott.emp;
create table dept as select * from scott.dept;
alter table dept add constraint dept_pk primary key(deptno);

create bitmap index emp_bm_idx
on emp( d.dname )
from emp e, dept d
where e.deptno = d.deptno
/
begin
dbms_stats.set_table_stats( user, 'EMP', 
                           numrows => 1000000, numblks => 300000 );
dbms_stats.set_table_stats( user, 'DEPT',
                           numrows => 100000, numblks => 30000 );
dbms_stats.delete_index_stats( user, 'EMP_BM_IDX' );
end;
/

set autotrace traceonly explain
select count(*)
from emp, dept
where emp.deptno = dept.deptno
and dept.dname = 'SALES'
/
select emp.*
  from emp, dept
 where emp.deptno = dept.deptno
   and dept.dname = 'SALES'
/
set autotrace off

