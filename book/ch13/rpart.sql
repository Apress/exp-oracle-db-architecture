connect /
set echo on
set linesize 1000
drop table order_line_items cascade constraints;
drop table orders cascade constraints;

clear screen
create table orders
( 
  order#      number primary key,
  order_date  date NOT NULL,
  data       varchar2(30)
)
enable row movement
PARTITION BY RANGE (order_date)
(
  PARTITION part_2009 VALUES LESS THAN (to_date('01-01-2010','dd-mm-yyyy')) ,
  PARTITION part_2010 VALUES LESS THAN (to_date('01-01-2011','dd-mm-yyyy')) 
)
/
insert into orders values 
( 1, to_date( '01-jun-2009', 'dd-mon-yyyy' ), 'xxx' );
insert into orders values 
( 2, to_date( '01-jun-2010', 'dd-mon-yyyy' ), 'xxx' );
create table order_line_items
( 
  order#      number,
  line#       number,
  order_date  date, -- manually copied from ORDERS!
  data       varchar2(30),
  constraint c1_pk primary key(order#,line#),
  constraint c1_fk_p foreign key(order#) references orders
)
enable row movement
PARTITION BY RANGE (order_date)
(
  PARTITION part_2009 VALUES LESS THAN (to_date('01-01-2010','dd-mm-yyyy')) ,
  PARTITION part_2010 VALUES LESS THAN (to_date('01-01-2011','dd-mm-yyyy')) 
)
/
insert into order_line_items values 
( 1, 1, to_date( '01-jun-2009', 'dd-mon-yyyy' ), 'yyy' );
insert into order_line_items values 
( 2, 1, to_date( '01-jun-2010', 'dd-mon-yyyy' ), 'yyy' );
alter table order_line_items drop partition part_2009;
alter table orders           drop partition part_2009;
pause


drop table order_line_items cascade constraints;

clear screen
truncate table orders;
insert into orders values 
( 1, to_date( '01-jun-2009', 'dd-mon-yyyy' ), 'xxx' );
insert into orders values 
( 2, to_date( '01-jun-2010', 'dd-mon-yyyy' ), 'xxx' );

create table order_line_items
( 
  order#      number NOT NULL,
  line#       number NOT NULL,
  data       varchar2(30),
  constraint c1_pk primary key(order#,line#),
  constraint c1_fk_p foreign key(order#) references orders
)
enable row movement
partition by reference(c1_fk_p)
/
insert into order_line_items values 
( 1, 1, 'yyy' );
insert into order_line_items values 
( 2, 1, 'yyy' );

select table_name, partition_name
  from user_tab_partitions
 where table_name in ( 'ORDERS', 'ORDER_LINE_ITEMS' )
 order by table_name, partition_name
/

alter table orders drop partition part_2009 update global indexes;
select table_name, partition_name
  from user_tab_partitions
 where table_name in ( 'ORDERS', 'ORDER_LINE_ITEMS' )
 order by table_name, partition_name
/

alter table orders add partition
part_2011 values less than
(to_date( '01-01-2012', 'dd-mm-yyyy' ));
select table_name, partition_name
  from user_tab_partitions
 where table_name in ( 'ORDERS', 'ORDER_LINE_ITEMS' )
 order by table_name, partition_name
/

select '2010', count(*) from order_line_items partition(part_2010) 
union all
select '2011', count(*) from order_line_items partition(part_2011);

update orders set order_date = add_months(order_date,12);

select '2010', count(*) from order_line_items partition(part_2010) 
union all
select '2011', count(*) from order_line_items partition(part_2011);

