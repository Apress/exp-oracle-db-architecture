create table list_example
( state_cd   varchar2(2),
  data       varchar2(20)
)
partition by list(state_cd)
( partition part_1 values ( 'ME', 'NH', 'VT', 'MA' ),
  partition part_2 values ( 'CT', 'RI', 'NY' )
)
/
insert into list_example values ( 'VA', 'data' );
alter table list_example
add partition
part_3 values ( DEFAULT );
insert into list_example values ( 'VA', 'data' );
alter table list_example
add partition
part_4 values( 'CA', 'NM' );

