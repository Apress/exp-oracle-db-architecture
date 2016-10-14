 create table t ( x int );
 create index t_idx on
 t( case when x = 42 then 1 end );
 set autotrace traceonly explain
 select /*+ index( t t_idx ) */ *
   from t
  where (case when x = 42 then 1 end ) = 1;
set autotrace off
 select column_expression
   from user_ind_expressions
  where index_name = 'T_IDX';
 set autotrace traceonly explain
 select /*+ index( t t_idx ) */ *
   from t
  where (case when x = 42 then 1 end ) = 1;

