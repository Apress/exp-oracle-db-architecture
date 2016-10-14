CREATE TABLE range_example
( range_key_column date ,
  data             varchar2(20)
)
PARTITION BY RANGE (range_key_column)
( PARTITION part_1 VALUES LESS THAN
       (to_date('01/01/2005','dd/mm/yyyy')),
  PARTITION part_2 VALUES LESS THAN
       (to_date('01/01/2006','dd/mm/yyyy')),
  PARTITION part_3 VALUES LESS THAN
       (MAXVALUE)
)
/

insert into range_example
( range_key_column, data )
values
( to_date( '15-dec-2004 00:00:00',
           'dd-mon-yyyy hh24:mi:ss' ),
  'application data...' );
insert into range_example
( range_key_column, data )
values
( to_date( '01-jan-2005 00:00:00',
           'dd-mon-yyyy hh24:mi:ss' )-1/24/60/60,
  'application data...' );
select * from range_example partition(part_1);
update range_example
   set range_key_column = trunc(range_key_column)
 where range_key_column =
    to_date( '31-dec-2004 23:59:59',
             'dd-mon-yyyy hh24:mi:ss' );
update range_example
   set range_key_column = to_date('02-jan-2005','dd-mon-yyyy')
 where range_key_column = to_date('31-dec-2004','dd-mon-yyyy');
select rowid
  from range_example
 where range_key_column = to_date('31-dec-2004','dd-mon-yyyy');
alter table range_example
enable row movement;
update range_example
   set range_key_column = to_date('02-jan-2005','dd-mon-yyyy')
 where range_key_column = to_date('31-dec-2004','dd-mon-yyyy');
select rowid
  from range_example
 where range_key_column = to_date('02-jan-2005','dd-mon-yyyy');
