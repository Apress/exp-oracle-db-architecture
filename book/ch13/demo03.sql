set echo on
drop table range_example;

CREATE TABLE range_example
( range_key_column date ,
  data             varchar2(20)
)
PARTITION BY RANGE (range_key_column)
( PARTITION part_1 VALUES LESS THAN
       (to_date('01/01/2010','dd/mm/yyyy')),
  PARTITION part_2 VALUES LESS THAN
       (to_date('01/01/2011','dd/mm/yyyy'))
)
/
insert into range_example
( range_key_column, data )
values
( to_date( '15/12/2012 00:00:00',
           'dd/mm/yyyy hh24:mi:ss' ),
  'application data...' );


insert into range_example
( range_key_column, data )
values
( to_date( '15-dec-2009 00:00:00',
           'dd-mon-yyyy hh24:mi:ss' ),
  'application data...' );
insert into range_example
( range_key_column, data )
values
( to_date( '31-dec-2009 23:59:59',
           'dd-mon-yyyy hh24:mi:ss' ),
  'application data...' );
insert into range_example
( range_key_column, data )
values
( to_date( '01-jan-2010 00:00:00',
           'dd-mon-yyyy hh24:mi:ss' ),
  'application data...' );
insert into range_example
( range_key_column, data )
values
( to_date( '31-dec-2010 00:00:00',
           'dd-mon-yyyy hh24:mi:ss' ),
  'application data...' );

insert into range_example
( range_key_column, data )
values
( to_date( '31-dec-2012 00:00:00',
           'dd-mon-yyyy hh24:mi:ss' ),
  'application data...' );
select to_char(range_key_column,'dd-mon-yyyy hh24:mi:ss')
  from range_example partition (part_1);
select to_char(range_key_column,'dd-mon-yyyy hh24:mi:ss')
  from range_example partition (part_2);

drop table range_example;


CREATE TABLE range_example
( range_key_column date ,
  data             varchar2(20)
)
PARTITION BY RANGE (range_key_column)
( PARTITION part_1 VALUES LESS THAN
       (to_date('01/01/2010','dd/mm/yyyy')),
  PARTITION part_2 VALUES LESS THAN
       (to_date('01/01/2011','dd/mm/yyyy')),
  PARTITION part_3 VALUES LESS THAN
       (MAXVALUE)
)
/
