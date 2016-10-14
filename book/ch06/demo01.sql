connect scott/tiger
set echo on

select empno, ename, sal from emp where deptno = 10;
variable empno number
variable ename varchar2(20)
variable sal number
exec :empno := 7934; :ename := 'MILLER'; :sal := 1300;
select empno, ename, sal
  from emp
 where empno = :empno
   and decode( ename, :ename, 1 ) = 1
   and decode( sal, :sal, 1 ) = 1
   for update nowait
/


update emp
   set ename = :ename, sal = :sal
 where empno = :empno;
commit;

