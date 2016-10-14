drop table composite_example;

CREATE TABLE composite_example
( range_key_column   date,
  hash_key_column    int,
  data               varchar2(20)
)
PARTITION BY RANGE (range_key_column)
subpartition by hash(hash_key_column) subpartitions 2
(
PARTITION part_1
     VALUES LESS THAN(to_date('01/01/2008','dd/mm/yyyy'))
     (subpartition part_1_sub_1,
      subpartition part_1_sub_2
     ),
PARTITION part_2
    VALUES LESS THAN(to_date('01/01/2011','dd/mm/yyyy'))
    (subpartition part_2_sub_1,
     subpartition part_2_sub_2
    )
)
/
Insert into composite_example
( range_key_column, hash_key_column, data )
Values
( to_date( '23-feb-2007', 'dd-mon-yyyy' ),
  123,
 'application_data' );

Insert into composite_example
( range_key_column, hash_key_column, data )
Values
( to_date( '27-feb-2010', 'dd-mon-yyyy' ),
  456,
 'application_data' );


select range_key_column,hash_key_column,'part_1_sub_1' from composite_example subpartition(part_1_sub_1) union all
select range_key_column,hash_key_column,'part_1_sub_2' from composite_example subpartition(part_1_sub_2) union all
select range_key_column,hash_key_column,'part_2_sub_1' from composite_example subpartition(part_2_sub_1) union all
select range_key_column,hash_key_column,'part_2_sub_2' from composite_example subpartition(part_2_sub_2);

drop TABLE composite_range_list_example;
CREATE TABLE composite_range_list_example
( range_key_column   date,
  code_key_column    int,
  data               varchar2(20)
)
PARTITION BY RANGE (range_key_column)
subpartition by list(code_key_column)
(
PARTITION part_1
     VALUES LESS THAN(to_date('01/01/2008','dd/mm/yyyy'))
     (subpartition part_1_sub_1 values( 1, 3, 5, 7 ),
      subpartition part_1_sub_2 values( 2, 4, 6, 8 )
     ),
PARTITION part_2
    VALUES LESS THAN(to_date('01/01/2011','dd/mm/yyyy'))
    (subpartition part_2_sub_1 values ( 1, 3 ),
     subpartition part_2_sub_2 values ( 5, 7 ),
     subpartition part_2_sub_3 values ( 2, 4, 6, 8 )
    )
)
/
