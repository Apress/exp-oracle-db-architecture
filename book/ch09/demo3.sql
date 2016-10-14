/*

drop table big_table;
drop table t;

@big_table 1000000

create table t
as
select * from big_table where 1=0;
*/

truncate table t;

declare
    l_redo number;
    l_cpu  number;
    l_ela  number;
begin
    dbms_output.put_line
    ( '-' || '      Rows' || '        Redo' ||
      '     CPU' || ' Elapsed' );
    for i in 1 .. 6
    loop
        l_redo := get_stat_val( 'redo size' );
        insert into t select * from big_table where rownum <= power(10,i);
        l_cpu  := dbms_utility.get_cpu_time;
        l_ela  := dbms_utility.get_time;
        --commit work write wait;
		rollback;
        dbms_output.put_line
        ( '-' ||
          to_char( power( 10, i ), '9,999,999') ||
          to_char( (get_stat_val('redo size')-l_redo), '999,999,999' ) ||
          to_char( (dbms_utility.get_cpu_time-l_cpu), '999,999' ) || 
          to_char( (dbms_utility.get_time-l_ela), '999,999' ) );
    end loop;
end;
/
