create table t
( char_column      char(20),
  varchar2_column  varchar2(20)
)
/
insert into t values ( 'Hello World', 'Hello World' );
select * from t;
select * from t where char_column = 'Hello World';
select * from t where varchar2_column = 'Hello World';
select * from t where char_column = varchar2_column;
select * from t where trim(char_column) = varchar2_column;
select * from t where char_column = rpad( varchar2_column, 20 );
variable varchar2_bv varchar2(20)
exec :varchar2_bv := 'Hello World';
select * from t where char_column = :varchar2_bv;
select * from t where varchar2_column = :varchar2_bv;
variable char_bv char(20)
exec :char_bv := 'Hello World';
select * from t where char_column = :char_bv;
select * from t where varchar2_column = :char_bv;

