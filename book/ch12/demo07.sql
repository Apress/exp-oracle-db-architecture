create table t
( num_type     number,
  float_type   binary_float,
  double_type  binary_double
)
/
insert /*+ APPEND */  into t
select rownum, rownum, rownum
  from all_objects
/
commit;
select sum(ln(num_type)) from t;
select sum(ln(float_type)) from t;
select sum(ln(double_type)) from t;
select sum(ln(cast( num_type as binary_double ) )) from t;

