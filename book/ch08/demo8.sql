spool x
set echo on

drop table t;
create table t as select * from all_objects;
exec dbms_stats.gather_table_stats( user, 'T' );

variable n number
exec :n := dbms_utility.get_cpu_time;
update t set object_name = lower(object_name);
exec dbms_output.put_line( (dbms_utility.get_cpu_time-:n) || ' cpu hsecs...' );

drop table t;
create table t as select * from all_objects;
exec dbms_stats.gather_table_stats( user, 'T' );
exec :n := dbms_utility.get_cpu_time;
begin
   for x in ( select rowid rid, object_name, rownum r
                from t )
   loop
        update t
           set object_name = lower(x.object_name)
         where rowid = x.rid;
        if ( mod(x.r,100) = 0 ) then
           commit;
        end if;
   end loop;
   commit;
end;
/
exec dbms_output.put_line( (dbms_utility.get_cpu_time-:n) || ' cpu hsecs...' );

drop table t;
create table t as select * from all_objects;
exec dbms_stats.gather_table_stats( user, 'T' );
exec :n := dbms_utility.get_cpu_time;
declare
    type ridArray is table of rowid;
    type vcArray is table of t.object_name%type;

    l_rids  ridArray;
    l_names vcArray;

    cursor c is select rowid, object_name from t;
begin
    open c;
    loop
        fetch c bulk collect into l_rids, l_names LIMIT 100;
        forall i in 1 .. l_rids.count
            update t
               set object_name = lower(l_names(i))
             where rowid = l_rids(i);
        commit;
        exit when c%notfound;
    end loop;
    close c;
end;
/
exec dbms_output.put_line( (dbms_utility.get_cpu_time-:n) || ' cpu hsecs...' );
spool off
