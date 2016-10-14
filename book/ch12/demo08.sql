select *
from all_views
where text like '%HELLO%';
select table_name, column_name
from dba_tab_columns
where data_type in ( 'LONG', 'LONG RAW' )
and owner = 'SYS'
and table_name like 'DBA%';
create or replace package long_help
authid current_user
as
    function substr_of
    ( p_query in varchar2,
      p_from  in number,
      p_for   in number,
      p_name1 in varchar2 default NULL,
      p_bind1 in varchar2 default NULL,
      p_name2 in varchar2 default NULL,
      p_bind2 in varchar2 default NULL,
      p_name3 in varchar2 default NULL,
      p_bind3 in varchar2 default NULL,
      p_name4 in varchar2 default NULL,
      p_bind4 in varchar2 default NULL )
    return varchar2;
end;
/
create or replace package body long_help
as

    g_cursor number := dbms_sql.open_cursor;
    g_query  varchar2(32765);

procedure bind_variable( p_name in varchar2, p_value in varchar2 )
is
begin
    if ( p_name is not null )
    then
        dbms_sql.bind_variable( g_cursor, p_name, p_value );
    end if;
end;


function substr_of
( p_query in varchar2,
  p_from  in number,
  p_for   in number,
  p_name1 in varchar2 default NULL,
  p_bind1 in varchar2 default NULL,
  p_name2 in varchar2 default NULL,
  p_bind2 in varchar2 default NULL,
  p_name3 in varchar2 default NULL,
  p_bind3 in varchar2 default NULL,
  p_name4 in varchar2 default NULL,
  p_bind4 in varchar2 default NULL )
return varchar2
as
    l_buffer       varchar2(4000);
    l_buffer_len   number;
begin
    if ( nvl(p_from,0) <= 0 )
    then
        raise_application_error
        (-20002, 'From must be >= 1 (positive numbers)' );
    end if;
    if ( nvl(p_for,0) not between 1 and 4000 )
    then
        raise_application_error
        (-20003, 'For must be between 1 and 4000' );
    end if;

    if ( p_query <> g_query or g_query is NULL )
    then
        if ( upper(trim(nvl(p_query,'x'))) not like 'SELECT%')
        then
            raise_application_error
            (-20001, 'This must be a select only' );
        end if;
        dbms_sql.parse( g_cursor, p_query, dbms_sql.native );
        g_query := p_query;
    end if;
    bind_variable( p_name1, p_bind1 );
    bind_variable( p_name2, p_bind2 );
    bind_variable( p_name3, p_bind3 );
    bind_variable( p_name4, p_bind4 );

    dbms_sql.define_column_long(g_cursor, 1);
    if (dbms_sql.execute_and_fetch(g_cursor)>0)
    then
        dbms_sql.column_value_long
        (g_cursor, 1, p_for, p_from-1,
         l_buffer, l_buffer_len );
    end if;
    return l_buffer;
end substr_of;

end;
/ 
select *
  from (
select table_owner, table_name, partition_name,
       long_help.substr_of
       ( 'select high_value
            from all_tab_partitions
           where table_owner = :o
             and table_name = :n
             and partition_name = :p',
          1, 4000,
          'o', table_owner,
          'n', table_name,
          'p', partition_name ) high_value
  from all_tab_partitions
 where table_name = 'T'
   and table_owner = user
       )
 where high_value like '%2003%'
/

select *
  from (
select owner, view_name,
       long_help.substr_of( 'select text
                               from dba_views
                              where owner = :owner
                                and view_name = :view_name',
                             1, 4000,
                             'owner', owner,
                             'view_name', view_name ) substr_of_view_text
  from dba_views
 where owner = user
       )
 where upper(substr_of_view_text) like '%INNER%'
/
