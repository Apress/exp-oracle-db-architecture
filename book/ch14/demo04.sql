alter table big_table_et PARALLEL;


create tablespace lmt_uniform
datafile '/tmp/lmt_uniform.dbf' size 1048640K reuse
autoextend on next 100m
extent management local
uniform size 100m;
create tablespace lmt_auto
datafile '/tmp/lmt_auto.dbf' size 1048640K reuse
autoextend on next 100m
extent management local
autoallocate;
pause

drop table uniform_test;
create table uniform_test
parallel
tablespace lmt_uniform
as
select * from big_table_et;
drop table autoallocate_test;
create table autoallocate_test
parallel
tablespace lmt_auto
as
select * from big_table_et;
select sid, serial#, qcsid, qcserial#, degree
from v$px_session;

select segment_name, blocks, extents
from user_segments 
where segment_name in ( 'UNIFORM_TEST', 'AUTOALLOCATE_TEST' );
exec show_space('UNIFORM_TEST' );
exec show_space('AUTOALLOCATE_TEST' );
select segment_name, extent_id, blocks
from user_extents where segment_name = 'UNIFORM_TEST';
select segment_name, blocks, count(*)
from user_extents
where segment_name = 'AUTOALLOCATE_TEST'
group by segment_name, blocks
/

pause


alter session enable parallel dml;
insert /*+ append */ into UNIFORM_TEST 
select * from big_table_et;
insert /*+ append */ into AUTOALLOCATE_TEST 
select * from big_table_et;
commit;
exec show_space( 'UNIFORM_TEST' );
exec show_space( 'AUTOALLOCATE_TEST' );

