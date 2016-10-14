set echo on

drop table t_hashed;
drop table t_heap;
drop cluster hash_cluster;

create cluster hash_cluster
( hash_key number )
hashkeys 75000
size 150
/
create table t_hashed
cluster hash_cluster(object_id)
as
select *
  from all_objects
/                                           
alter table t_hashed add constraint 
t_hashed_pk primary key(object_id)
/
begin
  dbms_stats.gather_table_stats( user, 'T_HASHED' );
end;
/
create table t_heap
as
select *
  from t_hashed
/
alter table t_heap add constraint
t_heap_pk primary key(object_id)
/
begin
   dbms_stats.gather_table_stats( user, 'T_HEAP' );
end;
/
create or replace package state_pkg
as
    type array is table of t_hashed.object_id%type;
    g_data array;
end;
/
begin
    select object_id bulk collect into state_pkg.g_data
      from t_hashed
     order by dbms_random.random;
end;
/

declare
    l_rec t_hashed%rowtype;
begin
    for i in 1 .. state_pkg.g_data.count
    loop
        select * into l_rec from t_hashed 
        where object_id = state_pkg.g_data(i);
    end loop;
end;
/
declare
    l_rec t_heap%rowtype;
begin
    for i in 1 .. state_pkg.g_data.count
    loop
        select * into l_rec from t_heap 
        where object_id = state_pkg.g_data(i);
    end loop;
end;
/

exec runStats_pkg.rs_start;
declare
    l_rec t_hashed%rowtype;
begin
    for i in 1 .. state_pkg.g_data.count
    loop
        select * into l_rec from t_hashed 
        where object_id = state_pkg.g_data(i);
    end loop;
end;
/
exec runStats_pkg.rs_middle;
declare
    l_rec t_heap%rowtype;
begin
    for i in 1 .. state_pkg.g_data.count
    loop
        select * into l_rec from t_heap 
        where object_id = state_pkg.g_data(i);
    end loop;
end;
/
exec runStats_pkg.rs_stop;
pause

@trace
declare
    l_rec t_hashed%rowtype;
begin
    for i in 1 .. state_pkg.g_data.count
    loop
        select * into l_rec from t_hashed 
        where object_id = state_pkg.g_data(i);
    end loop;
end;
/
declare
    l_rec t_heap%rowtype;
begin
    for i in 1 .. state_pkg.g_data.count
    loop
        select * into l_rec from t_heap 
        where object_id = state_pkg.g_data(i);
    end loop;
end;
/
@tk "sys=no"


