connect /

drop table temp;
drop table perm;

create table perm
( x char(2000) ,
  y char(2000) ,
  z char(2000)  )
/
create global temporary table temp
( x char(2000) ,
  y char(2000) ,
  z char(2000)  )
on commit preserve rows
/
create index perm_idx on perm(x);
create index temp_idx on temp(x);

create or replace procedure do_sql( p_sql in varchar2 )
as
    l_start_redo    number;
    l_redo            number;
begin
	l_start_redo := get_stat_val( 'redo size' );

    execute immediate p_sql;
    commit;

	l_redo := get_stat_val( 'redo size' ) - l_start_redo;

    dbms_output.put_line
    ( to_char(l_redo,'99,999,999') ||' bytes of redo generated for "' ||
      substr( replace( p_sql, chr(10), ' '), 1, 25 ) || '"...' );
end;
/
set serveroutput on format wrapped
begin
    do_sql( 'insert into perm
             select 1,1,1
               from all_objects
              where rownum <= 500' );

    do_sql( 'insert into temp
             select 1,1,1
               from all_objects
              where rownum <= 500' );
    dbms_output.new_line;

    do_sql( 'update perm set x = 2' );
    do_sql( 'update temp set x = 2' );
    dbms_output.new_line;

    do_sql( 'delete from perm' );
    do_sql( 'delete from temp' );
end;
/
