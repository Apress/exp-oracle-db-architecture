set echo on
select log_mode from v$database;

drop table t;
variable redo number
exec :redo := get_stat_val( 'redo size' );
create table t
as
select * from all_objects;
exec dbms_output.put_line( (get_stat_val('redo size')-:redo) || ' bytes of redo generated...' );

drop table t;
variable redo number
exec :redo := get_stat_val( 'redo size' );
create table t
NOLOGGING
as
select * from all_objects;
exec dbms_output.put_line( (get_stat_val('redo size')-:redo) || ' bytes of redo generated...' );
