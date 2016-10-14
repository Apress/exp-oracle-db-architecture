set echo on

drop tablespace tde_test including contents and datafiles;

create tablespace tde_test datafile size 1m
/

create table t
( c1 varchar2(30),
  c2 varchar2(30) ENCRYPT
)
tablespace tde_test
/


insert into t values
( 'this_is_NOT_encrypted',
  'this_is_encrypted' );
commit;

select * from t;

alter system set encryption wallet close identified by foobar;

insert into t values
( 'this_is_NOT_encrypted',
  'this_is_encrypted' );
insert into t values
( 'this_is_NOT_encrypted',
  null );
select c1 from t;
select c2 from t;

alter system set encryption wallet open identified by foobar;
select * from t;

alter system checkpoint;
column file_name new_val f
select file_name
  from dba_data_files 
 where tablespace_name = 'TDE_TEST';

!strings -a &F 


drop tablespace tde_test including contents and datafiles;
