set echo on

show parameter dump_dest 

select name, value
  from v$parameter
 where name = 'user_dump_dest'
    or name = 'background_dump_dest'
    or name = 'core_dump_dest'
/
set serveroutput on
exec dbms_output.put_line( scott.get_param( 'user_dump_dest' ) )
