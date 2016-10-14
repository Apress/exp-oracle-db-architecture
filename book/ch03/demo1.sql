set echo on

connect / 


select value
  from v$parameter
 where name = 'db_block_size'
/

show parameter db_block_s

connect scott/tiger

select value
  from v$parameter
 where name = 'db_block_size'
/

show parameter db_block_s

create or replace 
function get_param( p_name in varchar2 )
return varchar2
as
    l_param_type  number;
    l_intval      binary_integer;
    l_strval      varchar2(256);
    invalid_parameter exception;
    pragma exception_init( invalid_parameter, -20000 );
begin
    begin
        l_param_type := 
        dbms_utility.get_parameter_value
        ( parnam => p_name, 
            intval => l_intval,
          strval => l_strval );
    exception
        when invalid_parameter
        then
            return '*access denied*';
    end;
    if ( l_param_type = 0 )
    then
        l_strval := to_char(l_intval);
    end if;
    return l_strval;
end get_param;
/

set serveroutput on
exec dbms_output.put_line( get_param( 'db_block_size' ) );
exec dbms_output.put_line( get_param( 'pga_aggregate_target' ) );

connect /
column name format a36
column val format a40
select name, scott.get_param( name ) val 
  from v$parameter 
 where scott.get_param( name ) = '*access denied*';

