/*

set echo on
set linesize 1000
drop table emp;


create table emp
as
select *
  from scott.emp
 where 1=0;
insert into emp
(empno,ename,job,mgr,hiredate,sal,comm,deptno)
select rownum empno,
       initcap(substr(object_name,1,10)) ename,
           substr(object_type,1,9) JOB,
       rownum MGR,
       created hiredate,
       rownum SAL,
       rownum COMM,
       (mod(rownum,4)+1)*10 DEPTNO
  from all_objects
 where rownum < 10000;
create index emp_upper_idx on emp(upper(ename));
begin
   dbms_stats.gather_table_stats
   (user,'EMP',cascade=>true);
end;
/
set autotrace traceonly explain
select *
  from emp
 where upper(ename) = 'KING';
set autotrace off


create or replace package stats
as
        cnt number default 0;
end;
/
create or replace
function my_soundex( p_string in varchar2 ) return varchar2
deterministic
as
    l_return_string varchar2(6) default substr( p_string, 1, 1 );
    l_char      varchar2(1);
    l_last_digit    number default 0;

    type vcArray is table of varchar2(10) index by binary_integer;
    l_code_table    vcArray;

begin
    stats.cnt := stats.cnt+1;

    l_code_table(1) := 'BPFV';
    l_code_table(2) := 'CSKGJQXZ';
    l_code_table(3) := 'DT';
    l_code_table(4) := 'L';
    l_code_table(5) := 'MN';
    l_code_table(6) := 'R';


    for i in 1 .. length(p_string)
    loop
        exit when (length(l_return_string) = 6);
        l_char := upper(substr( p_string, i, 1 ) );

        for j in 1 .. l_code_table.count
        loop
        if (instr(l_code_table(j), l_char ) > 0 AND j <> l_last_digit)
        then
            l_return_string := l_return_string || to_char(j,'fm9');
            l_last_digit := j;
        end if;
        end loop;
    end loop;

    return rpad( l_return_string, 6, '0' );
end;
/
set autotrace on explain
variable cpu number
exec :cpu := dbms_utility.get_cpu_time
select ename, hiredate
  from emp
 where my_soundex(ename) = my_soundex('Kings')
/
set autotrace off
begin
	dbms_output.put_line
	( 'cpu time = ' || round((dbms_utility.get_cpu_time-:cpu)/100,2) );
	dbms_output.put_line( 'function was called: ' || stats.cnt );
end;
/

create index emp_soundex_idx on
emp( substr(my_soundex(ename),1,6) )
/

REM reset our counter
exec stats.cnt := 0
 
variable cpu number
exec :cpu := dbms_utility.get_cpu_time
set autotrace on explain
select ename, hiredate
  from emp
 where substr(my_soundex(ename),1,6) = my_soundex('Kings')
/
set autotrace off
begin
	dbms_output.put_line
	( 'cpu time = ' || round((dbms_utility.get_cpu_time-:cpu)/100,2) );
	dbms_output.put_line( 'function was called: ' || stats.cnt );
end;
/

create or replace view emp_v
as
select ename, substr(my_soundex(ename),1,6) ename_soundex, hiredate
  from emp
/
 
exec stats.cnt := 0;
 
exec :cpu := dbms_utility.get_cpu_time
select ename, hiredate
  from emp_v
 where ename_soundex = my_soundex('Kings')
/
begin
	dbms_output.put_line
	( 'cpu time = ' || round((dbms_utility.get_cpu_time-:cpu)/100,2) );
	dbms_output.put_line( 'function was called: ' || stats.cnt );
end;
/

drop index emp_soundex_idx;


alter table emp
add
ename_soundex as
(substr(my_soundex(ename),1,6))
/

create index emp_soundex_idx
on emp(ename_soundex);

exec stats.cnt := 0;
exec :cpu := dbms_utility.get_cpu_time
select ename, hiredate
  from emp
 where ename_soundex = my_soundex('Kings')
/
begin
	dbms_output.put_line
	( 'cpu time = ' || round((dbms_utility.get_cpu_time-:cpu)/100,2) );
	dbms_output.put_line( 'function was called: ' || stats.cnt );
end;
/
*/

truncate table emp;
create index emp_soundex_idx
on emp(ename_soundex);
@trace
insert into emp indexed
(empno,ename,job,mgr,hiredate,sal,comm,deptno)
select rownum empno,
       initcap(substr(object_name,1,10)) ename,
           substr(object_type,1,9) JOB,
       rownum MGR,
       created hiredate,
       rownum SAL,
       rownum COMM,
       (mod(rownum,4)+1)*10 DEPTNO
  from all_objects
 where rownum < 10000;
truncate table emp;
drop index emp_soundex_idx;
insert into emp noindex
(empno,ename,job,mgr,hiredate,sal,comm,deptno)
select rownum empno,
       initcap(substr(object_name,1,10)) ename,
           substr(object_type,1,9) JOB,
       rownum MGR,
       created hiredate,
       rownum SAL,
       rownum COMM,
       (mod(rownum,4)+1)*10 DEPTNO
  from all_objects
 where rownum < 10000;
@tk "sys=no"
