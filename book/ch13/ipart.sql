connect /
set echo on
set linesize 1000
drop table audit_trail;

clear screen
create table audit_trail
( ts    timestamp,
  data  varchar2(30)
)
partition by range(ts)
interval (numtoyminterval(1,'month'))
store in (users, example )
(partition p0 values less than
 (to_date('01-01-1900','dd-mm-yyyy'))
)
/
pause
column partition_name format a10
column tablespace_name format a10
column high_value format a31
column interval format a30

clear screen
select a.partition_name, a.tablespace_name, a.high_value, 
       decode( a.interval, 'YES', b.interval ) interval
  from user_tab_partitions a, user_part_tables b
 where a.table_name = 'AUDIT_TRAIL'
   and a.table_name = b.table_name
 order by a.partition_position;
pause

column greater_than_eq_to format a32
column strictly_less_than format a32
clear screen
insert into audit_trail (ts,data) values 
( to_timestamp('27-feb-2010','dd-mon-yyyy'), 'xx' );
select a.partition_name, a.tablespace_name, a.high_value, 
       decode( a.interval, 'YES', b.interval ) interval
  from user_tab_partitions a, user_part_tables b
 where a.table_name = 'AUDIT_TRAIL'
   and a.table_name = b.table_name
 order by a.partition_position;

select TIMESTAMP' 2010-03-01 00:00:00'-NUMTOYMINTERVAL(1,'MONTH') greater_than_eq_to, 
       TIMESTAMP' 2010-03-01 00:00:00' strictly_less_than
  from dual
/
pause

clear screen
insert into audit_trail (ts,data) values 
( to_date('25-jun-2010','dd-mon-yyyy'), 'xx' );
select a.partition_name, a.tablespace_name, a.high_value, 
       decode( a.interval, 'YES', b.interval ) interval
  from user_tab_partitions a, user_part_tables b
 where a.table_name = 'AUDIT_TRAIL'
   and a.table_name = b.table_name
 order by a.partition_position;
pause



clear screen
insert into audit_trail (ts,data) values 
( to_date('15-mar-2010','dd-mon-yyyy'), 'xx' );
select a.partition_name, a.tablespace_name, a.high_value, 
       decode( a.interval, 'YES', b.interval ) interval
  from user_tab_partitions a, user_part_tables b
 where a.table_name = 'AUDIT_TRAIL'
   and a.table_name = b.table_name
 order by a.partition_position;
pause

clear screen
select * from audit_trail;
rollback;
select * from audit_trail;
select a.partition_name, a.tablespace_name, a.high_value, 
       decode( a.interval, 'YES', b.interval ) interval
  from user_tab_partitions a, user_part_tables b
 where a.table_name = 'AUDIT_TRAIL'
   and a.table_name = b.table_name
 order by a.partition_position;

column partition_name format a12
declare
    l_str varchar2(4000);
begin
    for x in ( select a.partition_name, a.tablespace_name, a.high_value
                 from user_tab_partitions a
                where a.table_name = 'AUDIT_TRAIL'
                  and a.interval = 'YES'
                  and a.partition_name like 'SYS\_P%' escape '\' )
    loop
        execute immediate 
        'select to_char( ' || x.high_value || 
                  '-numtodsinterval(1,''second''), ''"PART_"yyyy_mm'' ) from dual' 
           into l_str;
        execute immediate 
        'alter table audit_trail rename partition "' || 
            x.partition_name || '" to "' || l_str || '"';
    end loop;
end;
/
select a.partition_name, a.tablespace_name, a.high_value, 
       decode( a.interval, 'YES', b.interval ) interval
  from user_tab_partitions a, user_part_tables b
 where a.table_name = 'AUDIT_TRAIL'
   and a.table_name = b.table_name
 order by a.partition_position;

alter table audit_trail drop partition part_2010_03;

select a.partition_name, a.tablespace_name, a.high_value, 
       decode( a.interval, 'YES', b.interval ) interval
  from user_tab_partitions a, user_part_tables b
 where a.table_name = 'AUDIT_TRAIL'
   and a.table_name = b.table_name
 order by a.partition_position;

