set echo on
@runstats
drop table t purge;

create table t ( x int );
create or replace procedure proc1
as
begin
    for i in 1 .. 10000
    loop
        execute immediate
        'insert into t values ( :x )' using i;
    end loop;
end;
/

create or replace procedure proc2
as
begin
    for i in 1 .. 10000
    loop
        execute immediate
        'insert into t values ( '||i||')';
    end loop;
end;
/

set serveroutput on

exec runstats_pkg.rs_start
exec proc1
exec runstats_pkg.rs_middle
exec proc2
exec runstats_pkg.rs_stop(10000)
