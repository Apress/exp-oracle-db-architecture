set echo on
select index_name, blevel, num_rows
from user_indexes
where table_name = 'BIG_TABLE';
set autotrace traceonly statistics
select id from big_table where id = 42;
select id from big_table where id = 12345;
select id from big_table where id = 1234567;
set autotrace off
