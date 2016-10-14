set echo on
drop table hash_example;

CREATE TABLE hash_example
( hash_key_column   date,
  data              varchar2(20)
)
PARTITION BY HASH (hash_key_column)
( partition part_1 tablespace p1,
  partition part_2 tablespace p2
)
/
insert into hash_example
( hash_key_column, data )
values
( to_date( '25-jun-2010' ),
  'application data...' );

insert into hash_example
( hash_key_column, data )
values
( to_date( '27-feb-2010' ),
  'application data...' );

select 'p1', hash_key_column from hash_example partition(part_1) union all
select 'p2', hash_key_column from hash_example partition(part_2);

pause


create or replace
procedure hash_proc
          ( p_nhash in number,
            p_cursor out sys_refcursor )
authid current_user
as
    l_text     long;
    l_template long :=
           'select $POS$ oc, ''p$POS$'' pname, count(*) cnt ' ||
             'from t partition ( $PNAME$ ) union all ';
    table_or_view_does_not_exist exception;
    pragma exception_init( table_or_view_does_not_exist, -942 );
begin
    begin
        execute immediate 'drop table t';
    exception when table_or_view_does_not_exist
        then null;
    end;

    execute immediate '
    CREATE TABLE t ( id )
    partition by hash(id)
    partitions ' || p_nhash || '
    as
    select rownum
      from all_objects';

    for x in ( select partition_name pname,
                      PARTITION_POSITION pos
                 from user_tab_partitions
                where table_name = 'T'
                order by partition_position )
    loop
        l_text := l_text ||
                  replace(
                  replace(l_template,
                        '$POS$', x.pos),
                        '$PNAME$', x.pname );
    end loop;

    open p_cursor for
       'select pname, cnt,
          substr( rpad(''*'',30*round( cnt/max(cnt)over(),2),''*''),1,30) hg
          from (' || substr( l_text, 1, length(l_text)-11 ) || ')
         order by oc';

end;
/
variable x refcursor
set autoprint on
exec hash_proc( 4, :x );
exec hash_proc( 5, :x );
exec hash_proc( 6, :x );
exec hash_proc( 7, :x );
exec hash_proc( 8, :x );

