drop table t;
set echo on

create table t
( id number primary key,
  x char(2000),
  y char(2000),
  z char(2000)
)
/
exec dbms_stats.set_table_stats( user, 'T', numrows=>10000, numblks=>10000 );
declare
    l_rec t%rowtype;
begin
    for i in 1 .. 10000
    loop
        select * into l_rec from t where id=i;
    end loop;
end;
/

insert into t
select rownum, 'x', 'y', 'z'
  from all_objects
 where rownum <= 10000;
commit;

variable redo number
exec :redo := get_stat_val( 'redo size' );
declare
    l_rec t%rowtype;
begin
    for i in 1 .. 10000
    loop
        select * into l_rec from t where id=i;
    end loop;
end;
/
exec dbms_output.put_line( (get_stat_val('redo size')-:redo) -
|| ' bytes of redo generated...');

exec :redo := get_stat_val( 'redo size' );
declare
    l_rec t%rowtype;
begin
    for i in 1 .. 10000
    loop
        select * into l_rec from t where id=i;
    end loop;
end;
/
exec dbms_output.put_line( (get_stat_val('redo size')-:redo) -
|| ' bytes of redo generated...');


