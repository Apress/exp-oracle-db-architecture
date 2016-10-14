set echo on
drop table emp;


CREATE TABLE emp
( empno   int,
  ename   varchar2(20)
)
PARTITION BY HASH (empno)
( partition part_1 tablespace p1,
  partition part_2 tablespace p2
)
/
insert into emp select empno, ename from scott.emp
/
select * from emp partition(part_1);
select * from emp partition(part_2);
alter tablespace p1 offline;
select * from emp;
variable n number
exec :n := 7844;
select * from emp where empno = :n;

