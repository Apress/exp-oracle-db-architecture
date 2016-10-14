create table t
( id       int primary key,
  os_file  bfile
)
/
create or replace directory my_dir as '/tmp/'
/
insert into t values ( 1, bfilename( 'MY_DIR', 'test.dbf' ) );
select dbms_lob.getlength(os_file) from t;
update t set os_file = bfilename( 'my_dir', 'test.dbf' );
select dbms_lob.getlength(os_file) from t;
create or replace directory "my_dir" as '/tmp/'
/
select dbms_lob.getlength(os_file) from t;

