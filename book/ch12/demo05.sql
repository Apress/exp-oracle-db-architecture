create table t
( num_col   number,
  float_col binary_float,
  dbl_col   binary_double
)
/
insert into t ( num_col, float_col, dbl_col )
values ( 1234567890.0987654321,
         1234567890.0987654321,
         1234567890.0987654321 );
set numformat 99999999999.99999999999
select * from t;
delete from t;
insert into t ( num_col, float_col, dbl_col )
values ( 9999999999.9999999999,
         9999999999.9999999999,
         9999999999.9999999999 );
select * from t;
delete from t;
insert into t ( num_col )
values ( 123 * 1e20 + 123*1e-20 ) ;
set numformat 999999999999999999999999.999999999999999999999999
select num_col, 123*1e20, 123*1e-20 from t;
select num_col from t where num_col = 123*1e20;
