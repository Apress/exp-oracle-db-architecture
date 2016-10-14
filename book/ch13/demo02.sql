create table big_table1
( ID, OWNER, OBJECT_NAME, SUBOBJECT_NAME,
  OBJECT_ID, DATA_OBJECT_ID,
  OBJECT_TYPE, CREATED, LAST_DDL_TIME,
  TIMESTAMP, STATUS, TEMPORARY,
  GENERATED, SECONDARY )
tablespace big1
as
select ID, OWNER, OBJECT_NAME, SUBOBJECT_NAME,
       OBJECT_ID, DATA_OBJECT_ID,
       OBJECT_TYPE, CREATED, LAST_DDL_TIME,
       TIMESTAMP, STATUS, TEMPORARY,
       GENERATED, SECONDARY
  from big_table.big_table ;
create table big_table2
( ID, OWNER, OBJECT_NAME, SUBOBJECT_NAME,
  OBJECT_ID, DATA_OBJECT_ID,
  OBJECT_TYPE, CREATED, LAST_DDL_TIME,
  TIMESTAMP, STATUS, TEMPORARY,
  GENERATED, SECONDARY )
partition by hash(id)
(partition part_1 tablespace big2,
 partition part_2 tablespace big2,
 partition part_3 tablespace big2,
 partition part_4 tablespace big2,
 partition part_5 tablespace big2,
 partition part_6 tablespace big2,
 partition part_7 tablespace big2,
 partition part_8 tablespace big2
)
as
select ID, OWNER, OBJECT_NAME, SUBOBJECT_NAME,
       OBJECT_ID, DATA_OBJECT_ID,
       OBJECT_TYPE, CREATED, LAST_DDL_TIME,
       TIMESTAMP, STATUS, TEMPORARY,
       GENERATED, SECONDARY
  from big_table.big_table ;
select b.tablespace_name,
       mbytes_alloc,
       mbytes_free
  from ( select round(sum(bytes)/1024/1024) mbytes_free,
                tablespace_name
           from dba_free_space
          group by tablespace_name ) a,
       ( select round(sum(bytes)/1024/1024) mbytes_alloc,
                tablespace_name
           from dba_data_files
          group by tablespace_name ) b
 where a.tablespace_name (+) = b.tablespace_name
   and b.tablespace_name in ('BIG1','BIG2')
/
alter table big_table1 move;
alter table big_table2 move;
alter table big_table2 move partition part_1;
alter table big_table2 move partition part_2;
alter table big_table2 move partition part_3;
alter table big_table2 move partition part_4;
alter table big_table2 move partition part_5;
alter table big_table2 move partition part_6;
alter table big_table2 move partition part_7;
alter table big_table2 move partition part_8;
begin
    for x in ( select partition_name
                 from user_tab_partitions
                where table_name = 'BIG_TABLE2' )
    loop
        execute immediate
        'alter table big_table2 move partition ' ||
         x.partition_name;
    end loop;
end;
/

