create table t ( x int, constraint t_pk primary key(x) );
insert into t values (1);
insert into t values (2);
insert into t values (9999999999);
analyze index t_pk validate structure;
select lf_blks, br_blks, btree_space
  from index_stats;
begin
        for i in 2 .. 999999
        loop
                delete from t where x = i;
                commit;
                insert into t values (i+1);
                commit;
        end loop;
end;
/
analyze index t_pk validate structure;
select lf_blks, br_blks, btree_space
  from index_stats;

