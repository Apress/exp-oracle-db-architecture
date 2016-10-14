set echo on
drop table t;
create table t as select * from all_objects;
create index t_idx on t(object_name);
exec dbms_stats.gather_table_stats( user, 'T', cascade=>true );
create undo tablespace undo_small
datafile '/home/ora11gr2/app/ora11gr2/oradata/orcl/undo_small.dbf' 
size 10m reuse
autoextend off
/
alter system set undo_tablespace = undo_small;
begin
    for x in ( select /*+ INDEX(t t_idx) */ rowid rid, object_name, rownum r
                 from t
                where object_name > ' ' )
    loop
        update t
           set object_name = lower(x.object_name)
         where rowid = x.rid;
        --if ( mod(x.r,100) = 0 ) then
         --  commit;
        --end if;
   end loop;
   commit;
end;
/
alter system set undo_tablespace = UNDOTBS1;
drop tablespace undo_small;
