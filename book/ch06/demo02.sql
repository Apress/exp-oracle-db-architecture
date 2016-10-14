connect /
drop table dept;
set echo on


create table dept
( deptno     number(2),
  dname      varchar2(14),
  loc        varchar2(13),
  last_mod   timestamp with time zone
             default systimestamp
             not null,
  constraint dept_pk primary key(deptno)
)
/
insert into dept( deptno, dname, loc )
select deptno, dname, loc
  from scott.dept;
commit;

variable deptno   number
variable dname    varchar2(14)
variable loc      varchar2(13)
variable last_mod varchar2(50)

begin
    :deptno := 10;
    select dname, loc, to_char( last_mod, 'DD-MON-YYYY HH.MI.SSXFF AM TZR' )
      into :dname,:loc,:last_mod
      from dept
     where deptno = :deptno;
end;
/
select :deptno dno, :dname dname, :loc loc, :last_mod lm
  from dual;
update dept
   set dname = initcap(:dname),
       last_mod = systimestamp
 where deptno = :deptno
   and last_mod = to_timestamp_tz(:last_mod, 'DD-MON-YYYY HH.MI.SSXFF AM TZR' );
update dept
   set dname = upper(:dname),
       last_mod = systimestamp
 where deptno = :deptno
   and last_mod = to_timestamp_tz(:last_mod, 'DD-MON-YYYY HH.MI.SSXFF AM TZR' );
