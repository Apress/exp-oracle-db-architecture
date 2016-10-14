drop table colocated;
drop table disorganized;
set echo on
set linesize 1000

create table colocated ( x int, y varchar2(80) );
begin
    for i in 1 .. 100000
    loop
        insert into colocated(x,y)
        values (i, rpad(dbms_random.random,75,'*') );
    end loop;
end;
/
alter table colocated
add constraint colocated_pk
primary key(x);
begin
dbms_stats.gather_table_stats( user, 'COLOCATED');
end;
/

create table disorganized
as
select x,y
  from colocated
 order by y;
alter table disorganized
add constraint disorganized_pk
primary key (x);
begin
dbms_stats.gather_table_stats( user, 'DISORGANIZED');
end;
/

set termout off
@trace
set arraysize 15
select * from colocated where x between 20000 and 40000;
select /*+ index( disorganized disorganized_pk ) */* from disorganized
   where x between 20000 and 40000;
select * from disorganized where x between 20000 and 40000;
select * from organized where x between 20000 and 40000;
select /*+ index( a15 disorganized_pk ) */ *
from disorganized a15 where x between 20000 and 40000;


set arraysize 100
select * from organized where x between 20000 and 40000;
select /*+ index( a100 disorganized_pk ) */ *
from disorganized a100 where x between 20000 and 40000;
select count(Y)
from
 (select /*+ INDEX(COLOCATED COLOCATED_PK) */ * from colocated);

select count(Y)
from
 (select /*+ INDEX(DISORGANIZED DISORGANIZED_PK) */ * from disorganized);
select * from colocated a15 where x between 20000 and 40000;
select * from colocated a100 where x between 20000 and 40000;

set termout on
disconnect
connect /
set arraysize 15
@trace
set termout off
select * from colocated where x between 20000 and 40000;
select /*+ index( disorganized disorganized_pk ) */* from disorganized
   where x between 20000 and 40000;
select * from colocated where x between 20000 and 40000;
select /*+ index( disorganized disorganized_pk ) */* from disorganized
   where x between 20000 and 40000;
select * from colocated where x between 20000 and 40000;
select /*+ index( disorganized disorganized_pk ) */* from disorganized
   where x between 20000 and 40000;
select * from colocated where x between 20000 and 40000;
select /*+ index( disorganized disorganized_pk ) */* from disorganized
   where x between 20000 and 40000;
select * from colocated where x between 20000 and 40000;
select /*+ index( disorganized disorganized_pk ) */* from disorganized
   where x between 20000 and 40000;
select * from disorganized where x between 20000 and 40000;
set termout on
pause
@tk "sys=no"


select table_name, blocks
from user_tables
where table_name in ( 'COLOCATED', 'DISORGANIZED' );


set autotrace traceonly statistics
set arraysize 15
select * from colocated a15 where x between 20000 and 40000;
select /*+ index( a15 disorganized_pk ) */ *
from disorganized a15 where x between 20000 and 40000;
set arraysize 100
select * from colocated a100 where x between 20000 and 40000;
select /*+ index( a100 disorganized_pk ) */ *
from disorganized a100 where x between 20000 and 40000;
set autotrace off
set arraysize 15


select a.index_name,
       b.num_rows,
       b.blocks,
       a.clustering_factor
  from user_indexes a, user_tables b
where index_name in ('COLOCATED_PK', 'DISORGANIZED_PK' )
  and a.table_name = b.table_name
/


@trace
set termout off 
select count(Y)
from
 (select /*+ INDEX(COLOCATED COLOCATED_PK) */ * from colocated);
select count(Y)
from
 (select /*+ INDEX(DISORGANIZED DISORGANIZED_PK) */ * from disorganized);
select * from colocated where x between 20000 and 30000;
select * from disorganized where x between 20000 and 30000;
set termout on
pause
@tk "sys=no"
